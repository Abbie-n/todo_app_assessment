import 'package:flutter/material.dart';
import 'package:todo_app_assessment/app/core/models/todo.dart';
import 'package:todo_app_assessment/app/features/todo/presentation/widgets/custom_check_box.dart';
import 'package:todo_app_assessment/app/features/todo/presentation/widgets/edit_todo_dialog.dart';

class TodoItem extends StatelessWidget {
  const TodoItem({
    super.key,
    required this.todo,
    required this.onComplete,
    required this.onEdit,
    required this.onDelete,
  });

  final Todo todo;
  final ValueChanged<Todo> onComplete;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      todo.title ?? '',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.none,
                        color: Colors.black,
                      ),
                    ),

                    if ((todo.description ?? '').isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          todo.description!,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.none,
                            color: Colors.black,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Spacer(),
              CustomCheckBox(
                onTap: () {
                  bool isComplete = todo.isComplete ?? false;
                  final updatedTodo = todo.copyWith(isComplete: !isComplete);
                  onComplete(updatedTodo);
                },
                selected: todo.isComplete ?? false,
                title: '',
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              InkWell(
                onTap: onDelete,
                child: Text(
                  'Delete',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.none,
                    color: Colors.red,
                  ),
                ),
              ),
              SizedBox(width: 16),
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => EditTodoDialog(todo: todo),
                  );
                },
                child: Text(
                  'Edit',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.none,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
