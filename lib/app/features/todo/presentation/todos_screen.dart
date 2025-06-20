import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app_assessment/app/core/routes/router.dart';
import 'package:todo_app_assessment/app/features/todo/presentation/notifier/delete_todo/delete_todo_notifier.dart';
import 'package:todo_app_assessment/app/features/todo/presentation/notifier/delete_todo/delete_todo_state.dart';
import 'package:todo_app_assessment/app/features/todo/presentation/notifier/get_todo/get_todos_notifier.dart';
import 'package:todo_app_assessment/app/features/todo/presentation/notifier/update_todo/update_todo_notifier.dart';
import 'package:todo_app_assessment/app/features/todo/presentation/notifier/update_todo/update_todo_state.dart';
import 'package:todo_app_assessment/app/features/todo/presentation/widgets/loading_widget.dart';
import 'package:todo_app_assessment/app/features/todo/presentation/widgets/todo_item.dart';

@RoutePage()
class TodosScreen extends HookConsumerWidget {
  const TodosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final getTodosNotifier = ref.watch(getTodosNotifierProvider.notifier);
    final getTodosState = ref.watch(getTodosNotifierProvider);
    final updateTodoNotifier = ref.watch(updateTodoNotifierProvider.notifier);
    final deleteTodoNotifier = ref.watch(deleteTodoNotifierProvider.notifier);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await getTodosNotifier.getAllTodos();
      });

      return;
    }, []);

    ref.listen<UpdateTodoState>(updateTodoNotifierProvider, (
      previous,
      current,
    ) {
      current.maybeWhen(
        finished: (result) async => await getTodosNotifier.getAllTodos(),
        orElse: () => null,
      );
    });

    ref.listen<DeleteTodoState>(deleteTodoNotifierProvider, (
      previous,
      current,
    ) {
      current.maybeWhen(
        finished: (result) async => await getTodosNotifier.getAllTodos(),
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
                'List of Todos',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.none,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 32),
              Expanded(
                child: getTodosState.maybeWhen(
                  loading: () => CircularLoadingWidget(),
                  finished: (data) {
                    if (data.isEmpty) {
                      return Center(
                        child: Text(
                          '"+" Add todos to see them here.',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.none,
                            color: Colors.black,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final todo = data[index];

                        return TodoItem(
                          todo: todo,
                          onComplete:
                              (value) => updateTodoNotifier.updateTodo(value),
                          onEdit: () => context.router.push(AddTodoRoute()),
                          onDelete:
                              () => deleteTodoNotifier.deleteTodo(todo.id!),
                        );
                      },
                    );
                  },
                  orElse: () => SizedBox.shrink(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
