import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:todo_app_assessment/app/core/routes/router.dart';

@RoutePage()
class HomeScreen extends HookWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentIndex = useState(0);

    useEffect(() {
      return null;
    }, []);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: AutoTabsScaffold(
        backgroundColor: Colors.white,
        routes: [TodosRoute(), AddTodoRoute()],
        bottomNavigationBuilder: (context, tabsRouter) {
          void updateRouter() {
            if (tabsRouter.activeIndex == currentIndex.value) {
              tabsRouter.stackRouterOfIndex(currentIndex.value)?.popUntilRoot();
            } else {
              tabsRouter.setActiveIndex(currentIndex.value);
            }
          }

          void setIndex(int index) {
            currentIndex.value = index;
            updateRouter();
          }

          return SafeArea(
            bottom: Platform.isIOS ? false : true,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                const SizedBox(height: 120),
                Container(
                  height: 110,
                  decoration: const BoxDecoration(color: Colors.black),
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildNavItem(
                          icon: Icons.list,
                          color:
                              tabsRouter.activeIndex == 0
                                  ? Colors.white
                                  : Colors.grey,
                          onTap: () => setIndex(0),
                        ),
                        _buildNavItem(
                          icon: Icons.add,
                          color:
                              tabsRouter.activeIndex == 1
                                  ? Colors.white
                                  : Colors.grey,
                          onTap: () => setIndex(1),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Icon(icon, size: 48, color: color),
      ),
    );
  }
}
