import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wanandroid_app_flutter_riverpod/shared/widgets/responsive/responsive_builder.dart';

class NaviPage extends ConsumerWidget {
  const NaviPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ResponsiveBuilder(
        mobile: _buildMobileLayout(context),
        smallTablet: _buildTabletLayout(context, crossAxisCount: 2),
        largeTablet: _buildTabletLayout(context, crossAxisCount: 3),
      ),
    );
  }

  /// 手机布局
  Widget _buildMobileLayout(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: const Text('导航'),
          backgroundColor: ColorScheme.of(context).inversePrimary,
          pinned: true,
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, int index) => _buildNaviCategoryItem(context, index),
            childCount: 5,
          ),
        ),
      ],
    );
  }

  /// 平板布局
  Widget _buildTabletLayout(
    BuildContext context, {
    required int crossAxisCount,
  }) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: const Text('导航'),
          backgroundColor: ColorScheme.of(context).inversePrimary,
          pinned: true,
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.2,
            ),
            delegate: SliverChildBuilderDelegate(
              (_, int index) => _buildNaviGridItem(context, index),
              childCount: 5,
            ),
          ),
        ),
      ],
    );
  }

  /// 导航分类列表项
  Widget _buildNaviCategoryItem(BuildContext context, int index) {
    final categories = ['Android', 'iOS', 'Flutter', '前端', '后端'];
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(
            context,
          ).primaryColor.withValues(alpha: 0.1),
          child: Icon(_getCategoryIcon(index)),
        ),
        title: Text(categories[index]),
        subtitle: Text('${(index + 1) * 3} 个网站'),
        children: List.generate(
          3,
          (subIndex) => ListTile(
            title: Text('${categories[index]} - 网站 ${subIndex + 1}'),
            trailing: const Icon(Icons.open_in_new, size: 16),
            onTap: () {
              // TODO: Open website
            },
          ),
        ),
      ),
    );
  }

  /// 导航网格项
  Widget _buildNaviGridItem(BuildContext context, int index) {
    final categories = ['Android', 'iOS', 'Flutter', '前端', '后端'];
    return Card(
      child: InkWell(
        onTap: () {
          // TODO: Show category detail
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getCategoryIcon(index),
                size: 48,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 12),
              Text(
                categories[index],
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                '${(index + 1) * 3} 个网站',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(int index) {
    const icons = [
      Icons.android,
      Icons.phone_iphone,
      Icons.flutter_dash,
      Icons.web,
      Icons.dns,
    ];
    return icons[index % icons.length];
  }
}
