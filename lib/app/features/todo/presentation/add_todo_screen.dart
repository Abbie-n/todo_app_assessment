import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app_assessment/app/core/models/todo.dart';
import 'package:todo_app_assessment/app/features/todo/presentation/notifier/add_todo/add_todo_notifier.dart';
import 'package:todo_app_assessment/app/features/todo/presentation/notifier/add_todo/add_todo_state.dart';
import 'package:todo_app_assessment/app/features/todo/presentation/notifier/get_todo/get_todos_notifier.dart';
import 'package:todo_app_assessment/app/features/todo/presentation/widgets/custom_button.dart';
import 'package:todo_app_assessment/app/features/todo/presentation/widgets/custom_textfield.dart';

@RoutePage()
class AddTodoScreen extends HookConsumerWidget {
  const AddTodoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(addTodoNotifierProvider.notifier);
    final state = ref.watch(addTodoNotifierProvider);
    final getTodosNotifier = ref.watch(getTodosNotifierProvider.notifier);

    final titleController = useTextEditingController();
    final descriptionController = useTextEditingController();
    final buttonEnabled = useState(false);

    bool changeListener() =>
        buttonEnabled.value = titleController.text.isNotEmpty;

    void resetForm() {
      titleController.clear();
      descriptionController.clear();
      changeListener();
    }

    ref.listen<AddTodoState>(addTodoNotifierProvider, (previous, current) {
      current.maybeWhen(
        finished: (result) async {
          if (result) {
            resetForm();
            await getTodosNotifier.getAllTodos();
          }
        },
        orElse: () => null,
      );
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Todo',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.none,
                  color: Colors.black,
                ),
              ),
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
                text: 'Done',
                loading: state.maybeWhen(
                  orElse: () => false,
                  loading: () => true,
                ),
                onPressed:
                    buttonEnabled.value
                        ? () async {
                          final todo = Todo(
                            description: descriptionController.text,
                            title: titleController.text,
                          );
                          await notifier.saveTodo(todo);
                        }
                        : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
