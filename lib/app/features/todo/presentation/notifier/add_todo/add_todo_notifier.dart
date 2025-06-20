import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:todo_app_assessment/app/core/models/todo.dart';
import 'package:todo_app_assessment/app/features/todo/presentation/notifier/add_todo/add_todo_state.dart';
import 'package:todo_app_assessment/app/features/todo/repository/todos_repository.dart';

final addTodoNotifierProvider =
    StateNotifierProvider<AddTodoNotifier, AddTodoState>(
      (ref) => AddTodoNotifier(ref.read(todosRepositoryProvider)),
    );

@lazySingleton
class AddTodoNotifier extends StateNotifier<AddTodoState> {
  final TodosRepository todosRepository;
  AddTodoNotifier(this.todosRepository) : super(const AddTodoState.initial());

  Future<void> saveTodo(Todo todo) async {
    state = const AddTodoState.loading();

    var result = await todosRepository.saveTodo(todo);
    state = AddTodoState.finished(result);
  }
}
