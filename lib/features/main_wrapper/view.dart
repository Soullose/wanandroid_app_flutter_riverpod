import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wanandroid_app_flutter_riverpod/shared/widgets/responsive/responsive_builder.dart';

class MainWrapperPage extends ConsumerWidget {
  const MainWrapperPage({required this.navigationShell, super.key});

  /// The navigation shell and container for the branch Navigators.
  final StatefulNavigationShell navigationShell;

  /// 导航目的地列表
  static const List<NavigationDestination> _destinations = [
    NavigationDestination(icon: Icon(Icons.home_filled), label: "首页"),
    NavigationDestination(icon: Icon(Icons.question_answer), label: "问答"),
    NavigationDestination(icon: Icon(Icons.route_rounded), label: "导航"),
    NavigationDestination(icon: Icon(Icons.person_rounded), label: "我的"),
  ];

  /// 导航Rail目的地列表
  static const List<NavigationRailDestination> _railDestinations = [
    NavigationRailDestination(icon: Icon(Icons.home_filled), label: Text("首页")),
    NavigationRailDestination(
      icon: Icon(Icons.question_answer),
      label: Text("问答"),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.route_rounded),
      label: Text("导航"),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.person_rounded),
      label: Text("我的"),
    ),
  ];

  void _onDestinationSelected(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: navigationShell.currentIndex == index,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ResponsiveBuilder(
      mobile: _buildMobileLayout(context),
      smallTablet: _buildTabletLayout(context, false),
      largeTablet: _buildTabletLayout(context, true),
    );
  }

  /// 手机布局：底部导航栏
  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        destinations: _destinations,
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _onDestinationSelected,
        animationDuration: const Duration(milliseconds: 1000),
      ),
    );
  }

  /// 平板布局：侧边NavigationRail
  Widget _buildTabletLayout(BuildContext context, bool isLargeTablet) {
    final isExtended = isLargeTablet;

    return Scaffold(
      body: Row(
        children: [
          // 侧边导航栏
          NavigationRail(
            destinations: _railDestinations,
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: _onDestinationSelected,
            extended: isExtended,
            minExtendedWidth: isLargeTablet ? 200 : null,
            leading: isExtended
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      '玩安卓',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : null,
            trailing: isExtended
                ? Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          'v1.0.0',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                      ),
                    ),
                  )
                : null,
          ),
          // 垂直分隔线
          VerticalDivider(
            thickness: 1,
            width: 1,
            color: Theme.of(context).dividerColor,
          ),
          // 主内容区域
          Expanded(child: navigationShell),
        ],
      ),
    );
  }
}
