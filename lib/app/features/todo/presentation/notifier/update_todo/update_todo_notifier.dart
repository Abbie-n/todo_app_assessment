import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:todo_app_assessment/app/core/models/todo.dart';
import 'package:todo_app_assessment/app/features/todo/presentation/notifier/update_todo/update_todo_state.dart';
import 'package:todo_app_assessment/app/features/todo/repository/todos_repository.dart';

final updateTodoNotifierProvider =
    StateNotifierProvider<UpdateTodoNotifier, UpdateTodoState>(
      (ref) => UpdateTodoNotifier(ref.read(todosRepositoryProvider)),
    );

@lazySingleton
class UpdateTodoNotifier extends StateNotifier<UpdateTodoState> {
  final TodosRepository todosRepository;
  UpdateTodoNotifier(this.todosRepository)
    : super(const UpdateTodoState.initial());

  Future<void> updateTodo(Todo todo) async {
    state = const UpdateTodoState.loading();

    var result = await todosRepository.updateTodo(todo);
    state = UpdateTodoState.finished(result);
  }
}
