import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MainWrapperPage extends ConsumerWidget {
  const MainWrapperPage({
    required this.navigationShell,
    Key? key,
  }) : super(key: key);

  /// The navigation shell and container for the branch Navigators.
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_filled), label: "首页"),
          NavigationDestination(icon: Icon(Icons.question_answer), label: "问答"),
          NavigationDestination(icon: Icon(Icons.route_rounded), label: "导航"),
          NavigationDestination(icon: Icon(Icons.person_rounded), label: "我的"),
        ],
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (int index) {
          return navigationShell.goBranch(index,
              initialLocation: navigationShell.currentIndex == index);
        },
        animationDuration: const Duration(milliseconds: 1000),
      ),
      body: navigationShell,
    );
  }
}
