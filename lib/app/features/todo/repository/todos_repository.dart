import 'package:injectable/injectable.dart';
import 'package:riverpod/riverpod.dart';
import 'package:todo_app_assessment/app/core/models/todo.dart';
import 'package:todo_app_assessment/app/core/services/native_storage_service.dart';

final todosRepositoryProvider = Provider<TodosRepository>(
  (ref) => TodosRepositoryImpl(
    storageService: ref.read(nativeStorageServiceProvider),
  ),
);

abstract class TodosRepository {
  Future<List<Todo>> getAllTodos();
  Future<bool> saveTodo(Todo todo);
  Future<bool> updateTodo(Todo todo);
  Future<bool> deleteTodo(String id);
}

@Injectable(as: TodosRepository)
class TodosRepositoryImpl implements TodosRepository {
  final NativeStorageService storageService;

  TodosRepositoryImpl({required this.storageService});

  @override
  Future<List<Todo>> getAllTodos() async {
    final data = await storageService.getAllTodos();
    final todos = <Todo>[];

    if (data.isNotEmpty) {
      for (var d in data) {
        todos.add(Todo.fromJson(d));
      }
      return todos;
    }

    return todos;
  }

  @override
  Future<bool> saveTodo(Todo todo) async {
    final data = await storageService.saveTodo(todo.toJson());
    return data;
  }

  @override
  Future<bool> updateTodo(Todo todo) async {
    final data = await storageService.updateTodo(todo.toJson());
    return data;
  }

  @override
  Future<bool> deleteTodo(String id) async {
    final data = await storageService.deleteTodo(id);
    return data;
  }
}
