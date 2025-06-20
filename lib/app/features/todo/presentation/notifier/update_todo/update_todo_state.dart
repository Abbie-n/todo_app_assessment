import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_todo_state.freezed.dart';

@freezed
class UpdateTodoState with _$UpdateTodoState {
  const factory UpdateTodoState.initial() = _Initial;
  const factory UpdateTodoState.loading() = _Loading;
  const factory UpdateTodoState.finished(bool result) = _Finished;
  const factory UpdateTodoState.error({required String message}) = _Error;
}
