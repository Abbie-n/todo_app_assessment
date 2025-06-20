import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:todo_app_assessment/app/features/todo/presentation/notifier/get_todo/get_todos_state.dart';
import 'package:todo_app_assessment/app/features/todo/repository/todos_repository.dart';

final getTodosNotifierProvider =
    StateNotifierProvider<GetTodosNotifier, GetTodosState>(
      (ref) => GetTodosNotifier(ref.read(todosRepositoryProvider)),
    );

@lazySingleton
class GetTodosNotifier extends StateNotifier<GetTodosState> {
  final TodosRepository todosRepository;
  GetTodosNotifier(this.todosRepository) : super(const GetTodosState.initial());

  Future<void> getAllTodos() async {
    state = const GetTodosState.loading();

    var result = await todosRepository.getAllTodos();
    state = GetTodosState.finished(result);
  }
}
