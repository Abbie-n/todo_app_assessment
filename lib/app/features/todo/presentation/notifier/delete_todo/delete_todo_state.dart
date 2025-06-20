import 'package:freezed_annotation/freezed_annotation.dart';

part 'delete_todo_state.freezed.dart';

@freezed
class DeleteTodoState with _$DeleteTodoState {
  const factory DeleteTodoState.initial() = _Initial;
  const factory DeleteTodoState.loading() = _Loading;
  const factory DeleteTodoState.finished(bool result) = _Finished;
  const factory DeleteTodoState.error({required String message}) = _Error;
}
