import 'package:auto_route/auto_route.dart';
import 'package:todo_app_assessment/app/features/home/presentation/home_screen.dart';
import 'package:todo_app_assessment/app/features/todo/presentation/add_todo_screen.dart';
import 'package:todo_app_assessment/app/features/todo/presentation/todos_screen.dart';

part 'router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      path: '/',
      page: HomeRoute.page,
      children: [
        AutoRoute(page: TodosRoute.page),
        AutoRoute(page: AddTodoRoute.page),
      ],
    ),
  ];
}
