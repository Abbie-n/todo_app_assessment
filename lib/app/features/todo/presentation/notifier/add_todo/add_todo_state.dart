import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_todo_state.freezed.dart';

@freezed
class AddTodoState with _$AddTodoState {
  const factory AddTodoState.initial() = _Initial;
  const factory AddTodoState.loading() = _Loading;
  const factory AddTodoState.finished(bool result) = _Finished;
  const factory AddTodoState.error({required String message}) = _Error;
}
