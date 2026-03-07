import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wanandroid_app_flutter_riverpod/shared/widgets/responsive/responsive_builder.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ResponsiveBuilder(
        mobile: _buildMobileLayout(context),
        smallTablet: _buildTabletLayout(context),
        largeTablet: _buildLargeTabletLayout(context),
      ),
    );
  }

  /// 手机布局
  Widget _buildMobileLayout(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: const Text('我的'),
          backgroundColor: ColorScheme.of(context).inversePrimary,
          pinned: true,
        ),
        // 用户信息卡片
        SliverToBoxAdapter(child: _buildUserCard(context)),
        // 菜单列表
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, int index) => _buildMenuItem(context, index),
            childCount: 6,
          ),
        ),
      ],
    );
  }

  /// 小平板布局
  Widget _buildTabletLayout(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: const Text('我的'),
          backgroundColor: ColorScheme.of(context).inversePrimary,
          pinned: true,
        ),
        SliverPadding(
          padding: const EdgeInsets.all(24),
          sliver: SliverToBoxAdapter(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 左侧用户信息
                Expanded(flex: 2, child: _buildUserCard(context)),
                const SizedBox(width: 24),
                // 右侧菜单
                Expanded(
                  flex: 3,
                  child: _buildMenuGrid(context, crossAxisCount: 2),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// 大平板布局
  Widget _buildLargeTabletLayout(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: const Text('我的'),
          backgroundColor: ColorScheme.of(context).inversePrimary,
          pinned: true,
        ),
        SliverPadding(
          padding: const EdgeInsets.all(32),
          sliver: SliverToBoxAdapter(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 左侧用户信息
                Expanded(flex: 1, child: _buildUserCard(context)),
                const SizedBox(width: 32),
                // 右侧菜单
                Expanded(
                  flex: 2,
                  child: _buildMenuGrid(context, crossAxisCount: 3),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// 用户信息卡片
  Widget _buildUserCard(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            CircleAvatar(
              radius: 48,
              backgroundColor: Theme.of(
                context,
              ).primaryColor.withValues(alpha: 0.1),
              child: Icon(
                Icons.person,
                size: 48,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            Text('用户名', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'user@example.com',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem(context, '收藏', '128'),
                _buildStatItem(context, '积分', '1024'),
                _buildStatItem(context, '排名', '256'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 统计项
  Widget _buildStatItem(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  /// 菜单项
  Widget _buildMenuItem(BuildContext context, int index) {
    final menuItems = [
      {'icon': Icons.favorite, 'title': '我的收藏', 'subtitle': '查看收藏的文章'},
      {'icon': Icons.history, 'title': '浏览历史', 'subtitle': '最近浏览的记录'},
      {'icon': Icons.article, 'title': '我的文章', 'subtitle': '我发布的文章'},
      {'icon': Icons.settings, 'title': '设置', 'subtitle': '应用设置'},
      {'icon': Icons.help, 'title': '帮助与反馈', 'subtitle': '常见问题和反馈'},
      {'icon': Icons.info, 'title': '关于', 'subtitle': '版本信息'},
    ];

    final item = menuItems[index];
    return ListTile(
      leading: Icon(item['icon'] as IconData),
      title: Text(item['title'] as String),
      subtitle: Text(item['subtitle'] as String),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        // TODO: Navigate to menu item
      },
    );
  }

  /// 菜单网格
  Widget _buildMenuGrid(BuildContext context, {required int crossAxisCount}) {
    final menuItems = [
      {'icon': Icons.favorite, 'title': '我的收藏'},
      {'icon': Icons.history, 'title': '浏览历史'},
      {'icon': Icons.article, 'title': '我的文章'},
      {'icon': Icons.settings, 'title': '设置'},
      {'icon': Icons.help, 'title': '帮助与反馈'},
      {'icon': Icons.info, 'title': '关于'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.5,
      ),
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        final item = menuItems[index];
        return Card(
          child: InkWell(
            onTap: () {
              // TODO: Navigate to menu item
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item['icon'] as IconData,
                  size: 32,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 8),
                Text(
                  item['title'] as String,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
