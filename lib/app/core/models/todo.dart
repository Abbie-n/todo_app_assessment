import 'package:json_annotation/json_annotation.dart';

part 'todo.g.dart';

@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class Todo {
  String? id;
  String? title;
  String? description;
  bool? isComplete;

  Todo({this.description, this.id, this.isComplete, this.title});

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);

  Map<String, dynamic> toJson() => _$TodoToJson(this);

  Todo copyWith({
    String? id,
    String? title,
    String? description,
    bool? isComplete,
  }) {
    return Todo(
      description: description ?? this.description,
      id: id ?? this.id,
      isComplete: isComplete ?? this.isComplete,
      title: title ?? this.title,
    );
  }
}
