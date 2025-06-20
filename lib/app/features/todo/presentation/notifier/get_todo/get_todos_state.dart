import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:todo_app_assessment/app/core/models/todo.dart';

part 'get_todos_state.freezed.dart';

@freezed
class GetTodosState with _$GetTodosState {
  const factory GetTodosState.initial() = _Initial;
  const factory GetTodosState.loading() = _Loading;
  const factory GetTodosState.finished(List<Todo> data) = _Finished;
  const factory GetTodosState.error({required String message}) = _Error;
}
