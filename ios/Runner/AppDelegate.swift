import Flutter
import Foundation
import UIKit

protocol OfflineClient {
    func getAllTodos() -> [Todo]
    func saveTodo(_ todo: Todo) -> Bool
    func updateTodo(_ todo: Todo) -> Bool
    func deleteTodo(id: String) -> Bool
}

struct Todo: Codable {
    let id: String
    let title: String
    let description: String?
    var isComplete: Bool

    // Convenience initializer for creating new todos (without ID)
    init(
        title: String, description: String? = nil, isComplete: Bool = false
    ) {
        self.id = ""
        self.title = title
        self.description = description
        self.isComplete = isComplete
    }

    // Full initializer with ID (used internally)
    init(id: String, title: String, description: String?, isComplete: Bool) {
        self.id = id
        self.title = title
        self.description = description
        self.isComplete = isComplete
    }
}

class OfflineClientImpl: OfflineClient {
    static let shared = OfflineClientImpl()
    private init() {}

    private let userDefaults = UserDefaults.standard
    private let todosKey = "todos"
    private let counterKey = "todo_counter"

    func getAllTodos() -> [Todo] {
        guard let data = userDefaults.data(forKey: todosKey) else { return [] }
        do {
            return try JSONDecoder().decode([Todo].self, from: data)
        } catch {
            print("Error decoding todos: \(error)")
            return []
        }
    }

    func saveTodo(_ todo: Todo) -> Bool {
        var todos = getAllTodos()

        // Generate new ID if the todo doesn't have one or has empty ID
        let todoWithId: Todo
        if todo.id.isEmpty {
            let newId = generateNextId()
            todoWithId = Todo(
                id: newId,
                title: todo.title,
                description: todo.description,
                isComplete: todo.isComplete,
            )
        } else {
            todoWithId = todo
        }

        todos.append(todoWithId)
        return saveAllTodos(todos)
    }

    func updateTodo(_ todo: Todo) -> Bool {
        var todos = getAllTodos()
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos[index] = todo
            return saveAllTodos(todos)
        }
        return false
    }

    func deleteTodo(id: String) -> Bool {
        var todos = getAllTodos()
        let initialCount = todos.count
        todos.removeAll { $0.id == id }

        // Return true only if something was actually deleted
        if todos.count < initialCount {
            return saveAllTodos(todos)
        }
        return false
    }

    private func saveAllTodos(_ todos: [Todo]) -> Bool {
        do {
            let data = try JSONEncoder().encode(todos)
            userDefaults.set(data, forKey: todosKey)
            return true
        } catch {
            print("Error encoding todos: \(error)")
            return false
        }
    }

    private func generateNextId() -> String {
        let currentCounter = userDefaults.integer(forKey: counterKey)
        let nextCounter = currentCounter + 1
        userDefaults.set(nextCounter, forKey: counterKey)
        return String(nextCounter)
    }
}

@main
class AppDelegate: FlutterAppDelegate {
    private let CHANNEL = "com.todo_app_assessment/offline_storage"

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)

        guard let controller = window?.rootViewController as? FlutterViewController else {
            fatalError("Root controller is not a FlutterViewController")
        }

        let methodChannel = FlutterMethodChannel(
            name: CHANNEL,
            binaryMessenger: controller.binaryMessenger
        )

        methodChannel.setMethodCallHandler {
            [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
            guard let self = self else { return }

            switch call.method {
            case "getAllTodos":
                self.getAllTodos(result: result)
            case "saveTodo":
                self.saveTodo(call: call, result: result)
            case "updateTodo":
                self.updateTodo(call: call, result: result)
            case "deleteTodo":
                self.deleteTodo(call: call, result: result)
            default:
                result(FlutterMethodNotImplemented)
            }
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    // MARK: - Todo Storage Methods

    private func getAllTodos(result: FlutterResult) {
        let todos = OfflineClientImpl.shared.getAllTodos()
        let todoMaps = todos.map { $0.toMap() }
        result(todoMaps)
    }

    private func saveTodo(call: FlutterMethodCall, result: FlutterResult) {
        guard let args = call.arguments as? [String: Any] else {
            result(
                FlutterError(
                    code: "INVALID_ARGUMENTS",
                    message: "Invalid arguments",
                    details: nil))
            return
        }

        // Validate required fields
        guard let title = args["title"] as? String, !title.isEmpty else {
            result(
                FlutterError(
                    code: "INVALID_TITLE",
                    message: "Title is required and cannot be empty",
                    details: nil))
            return
        }

        let todo = Todo.fromMap(args)
        let success = OfflineClientImpl.shared.saveTodo(todo)
        result(success)
    }

    private func updateTodo(call: FlutterMethodCall, result: FlutterResult) {
        guard let args = call.arguments as? [String: Any] else {
            result(
                FlutterError(
                    code: "INVALID_ARGUMENTS",
                    message: "Invalid arguments",
                    details: nil))
            return
        }

        // Validate required fields
        guard let id = args["id"] as? String, !id.isEmpty else {
            result(
                FlutterError(
                    code: "INVALID_ID",
                    message: "ID is required for updating",
                    details: nil))
            return
        }

        guard let title = args["title"] as? String, !title.isEmpty else {
            result(
                FlutterError(
                    code: "INVALID_TITLE",
                    message: "Title is required and cannot be empty",
                    details: nil))
            return
        }

        let todo = Todo.fromMap(args)
        let success = OfflineClientImpl.shared.updateTodo(todo)
        result(success)
    }

    private func deleteTodo(call: FlutterMethodCall, result: FlutterResult) {
        guard let id = call.arguments as? String, !id.isEmpty else {
            result(
                FlutterError(
                    code: "INVALID_ID",
                    message: "Valid ID is required for deletion",
                    details: nil))
            return
        }

        let success = OfflineClientImpl.shared.deleteTodo(id: id)
        result(success)
    }
}

// MARK: - Todo Model Extension

extension Todo {
    func toMap() -> [String: Any] {
        var map: [String: Any] = [
            "id": id,
            "title": title,
            "isComplete": isComplete,
        ]

        // Only include description if it's not nil
        if let description = description {
            map["description"] = description
        }

        return map
    }

    static func fromMap(_ map: [String: Any]) -> Todo {
        let id = (map["id"] as? String) ?? ""
        let title = (map["title"] as? String) ?? ""
        let description = map["description"] as? String
        let isComplete = (map["isComplete"] as? Bool) ?? false

        return Todo(
            id: id,
            title: title,
            description: description,
            isComplete: isComplete,
        )
    }
}
