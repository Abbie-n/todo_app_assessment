import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:todo_app_assessment/app/features/todo/presentation/notifier/delete_todo/delete_todo_state.dart';
import 'package:todo_app_assessment/app/features/todo/repository/todos_repository.dart';

final deleteTodoNotifierProvider =
    StateNotifierProvider<DeleteTodoNotifier, DeleteTodoState>(
      (ref) => DeleteTodoNotifier(ref.read(todosRepositoryProvider)),
    );

@lazySingleton
class DeleteTodoNotifier extends StateNotifier<DeleteTodoState> {
  final TodosRepository todosRepository;
  DeleteTodoNotifier(this.todosRepository)
    : super(const DeleteTodoState.initial());

  Future<void> deleteTodo(String id) async {
    state = const DeleteTodoState.loading();

    var result = await todosRepository.deleteTodo(id);
    state = DeleteTodoState.finished(result);
  }
}
