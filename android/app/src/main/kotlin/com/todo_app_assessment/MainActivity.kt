package com.todo_app_assessment

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Context
import android.content.SharedPreferences
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken

interface OfflineClient {
    fun getAllTodos(): List<Todo>
    fun saveTodo(todo: Todo): Boolean
    fun updateTodo(todo: Todo): Boolean
    fun deleteTodo(id: String): Boolean
}

data class Todo(
    val id: String,
    val title: String,
    val description: String?,
    var isComplete: Boolean
) {
    // Convenience initializer for creating new todos (without ID)
    constructor(title: String, description: String? = null, isComplete: Boolean = false) : 
        this("", title, description, isComplete)

    fun toMap(): Map<String, Any?> {
        return mutableMapOf<String, Any?>(
            "id" to id,
            "title" to title,
            "isComplete" to isComplete
        ).apply {
            if (description != null) {
                put("description", description)
            }
        }
    }

    companion object {
        fun fromMap(map: Map<*, *>): Todo {
            return Todo(
                id = map["id"]?.toString() ?: "",
                title = map["title"]?.toString() ?: "",
                description = map["description"]?.toString(),
                isComplete = map["isComplete"] as? Boolean ?: false
            )
        }
    }
}

class OfflineClientImpl private constructor(private val sharedPreferences: SharedPreferences) : OfflineClient {
    companion object {
        @Volatile
        private var INSTANCE: OfflineClientImpl? = null
        
        private const val PREFS_NAME = "todo_prefs"
        private const val TODOS_KEY = "todos"
        private const val COUNTER_KEY = "todo_counter"
        
        fun getInstance(context: Context): OfflineClientImpl {
            return INSTANCE ?: synchronized(this) {
                val instance = OfflineClientImpl(
                    context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
                )
                INSTANCE = instance
                instance
            }
        }
    }
    
    private val gson = Gson()
    
    override fun getAllTodos(): List<Todo> {
        val json = sharedPreferences.getString(TODOS_KEY, null)
        return if (json != null) {
            val type = object : TypeToken<List<Todo>>() {}.type
            gson.fromJson(json, type) ?: emptyList()
        } else {
            emptyList()
        }
    }
    
    override fun saveTodo(todo: Todo): Boolean {
        val todos = getAllTodos().toMutableList()
        
        // Generate new ID if the todo doesn't have one or has empty ID
        val todoWithId = if (todo.id.isEmpty()) {
            val newId = generateNextId()
            Todo(
                id = newId,
                title = todo.title,
                description = todo.description,
                isComplete = todo.isComplete
            )
        } else {
            todo
        }

        todos.add(todoWithId)
        return saveAllTodos(todos)
    }
    
    override fun updateTodo(todo: Todo): Boolean {
        val todos = getAllTodos().toMutableList()
        val index = todos.indexOfFirst { it.id == todo.id }
        if (index != -1) {
            todos[index] = todo
            return saveAllTodos(todos)
        }
        return false
    }
    
    override fun deleteTodo(id: String): Boolean {
        val todos = getAllTodos().toMutableList()
        val initialCount = todos.size
        todos.removeAll { it.id == id }

        // Return true only if something was actually deleted
        if (todos.size < initialCount) {
            return saveAllTodos(todos)
        }
        return false
    }
    
    private fun saveAllTodos(todos: List<Todo>): Boolean {
        val json = gson.toJson(todos)
        return sharedPreferences.edit()
            .putString(TODOS_KEY, json)
            .commit()
    }
    
    private fun generateNextId(): String {
        val currentCounter = sharedPreferences.getInt(COUNTER_KEY, 0)
        val nextCounter = currentCounter + 1
        sharedPreferences.edit()
            .putInt(COUNTER_KEY, nextCounter)
            .apply()
        return nextCounter.toString()
    }
}

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.todo_app_assessment/offline_storage"
    private lateinit var offlineClient: OfflineClient

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        offlineClient = OfflineClientImpl.getInstance(applicationContext)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getAllTodos" -> {
                    try {
                        val todos = offlineClient.getAllTodos()
                        result.success(todos.map { it.toMap() })
                    } catch (e: Exception) {
                        result.error("FETCH_FAILED", "Failed to fetch todos", e.localizedMessage)
                    }
                }
                "saveTodo" -> {
                    try {
                        val todoMap = call.arguments as? Map<*, *> ?: run {
                            result.error("INVALID_ARGUMENTS", "Invalid arguments", null)
                            return@setMethodCallHandler
                        }
                        
                        if (todoMap["title"] == null || (todoMap["title"] as? String).isNullOrEmpty()) {
                            result.error("INVALID_TITLE", "Title is required and cannot be empty", null)
                            return@setMethodCallHandler
                        }
                        
                        val todo = Todo.fromMap(todoMap)
                        val success = offlineClient.saveTodo(todo)
                        result.success(success)
                    } catch (e: Exception) {
                        result.error("SAVE_FAILED", "Failed to save todo", e.localizedMessage)
                    }
                }
                "updateTodo" -> {
                    try {
                        val todoMap = call.arguments as? Map<*, *> ?: run {
                            result.error("INVALID_ARGUMENTS", "Invalid arguments", null)
                            return@setMethodCallHandler
                        }
                        
                        if (todoMap["id"] == null || (todoMap["id"] as? String).isNullOrEmpty()) {
                            result.error("INVALID_ID", "ID is required for updating", null)
                            return@setMethodCallHandler
                        }
                        
                        if (todoMap["title"] == null || (todoMap["title"] as? String).isNullOrEmpty()) {
                            result.error("INVALID_TITLE", "Title is required and cannot be empty", null)
                            return@setMethodCallHandler
                        }
                        
                        val todo = Todo.fromMap(todoMap)
                        val success = offlineClient.updateTodo(todo)
                        result.success(success)
                    } catch (e: Exception) {
                        result.error("UPDATE_FAILED", "Failed to update todo", e.localizedMessage)
                    }
                }
                "deleteTodo" -> {
                    try {
                        val id = call.arguments as? String ?: run {
                            result.error("INVALID_ID", "Valid ID is required for deletion", null)
                            return@setMethodCallHandler
                        }
                        
                        if (id.isEmpty()) {
                            result.error("INVALID_ID", "Valid ID is required for deletion", null)
                            return@setMethodCallHandler
                        }
                        
                        val success = offlineClient.deleteTodo(id)
                        result.success(success)
                    } catch (e: Exception) {
                        result.error("DELETE_FAILED", "Failed to delete todo", e.localizedMessage)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}