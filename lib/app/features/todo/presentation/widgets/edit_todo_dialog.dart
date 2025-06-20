import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app_assessment/app/core/models/todo.dart';
import 'package:todo_app_assessment/app/features/todo/presentation/notifier/get_todo/get_todos_notifier.dart';
import 'package:todo_app_assessment/app/features/todo/presentation/notifier/update_todo/update_todo_notifier.dart';
import 'package:todo_app_assessment/app/features/todo/presentation/notifier/update_todo/update_todo_state.dart';
import 'package:todo_app_assessment/app/features/todo/presentation/widgets/custom_button.dart';
import 'package:todo_app_assessment/app/features/todo/presentation/widgets/custom_textfield.dart';

class EditTodoDialog extends HookConsumerWidget {
  const EditTodoDialog({super.key, required this.todo});

  final Todo todo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(updateTodoNotifierProvider.notifier);
    final state = ref.watch(updateTodoNotifierProvider);
    final getTodosNotifier = ref.watch(getTodosNotifierProvider.notifier);

    final titleController = useTextEditingController(text: todo.title);
    final descriptionController = useTextEditingController(
      text: todo.description,
    );
    final buttonEnabled = useState(false);

    bool changeListener() =>
        buttonEnabled.value = titleController.text.isNotEmpty;

    useEffect(() {
      changeListener();

      return;
    });

    ref.listen<UpdateTodoState>(updateTodoNotifierProvider, (
      previous,
      current,
    ) {
      current.maybeWhen(
        finished: (result) async {
          await getTodosNotifier.getAllTodos();

          if (context.mounted) {
            context.maybePop();
          }
        },
        orElse: () => null,
      );
    });

    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(onTap: () => context.maybePop(), child: Icon(Icons.close)),
            SizedBox(height: 32),
            CustomTextField(
              controller: titleController,
              onChanged: (value) => changeListener(),
              label: 'Title*',
            ),
            SizedBox(height: 32),
            CustomTextField(
              controller: descriptionController,
              maxLines: 4,
              onChanged: (value) => changeListener(),
              label: 'Description',
            ),
            SizedBox(height: 32),
            CustomButton(
              text: 'Update',
              loading: state.maybeWhen(
                orElse: () => false,
                loading: () => true,
              ),
              onPressed:
                  buttonEnabled.value
                      ? () async {
                        final updatedTodo = todo.copyWith(
                          description: descriptionController.text,
                          title: titleController.text,
                        );
                        await notifier.updateTodo(updatedTodo);
                      }
                      : null,
            ),
          ],
        ),
      ),
    );
  }
}
