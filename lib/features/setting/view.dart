import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wanandroid_app_flutter_riverpod/shared/theme/app_theme_mode.dart';
import 'package:wanandroid_app_flutter_riverpod/shared/widgets/responsive/responsive_builder.dart';

class SettingPage extends ConsumerWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return ResponsiveBuilder(
      mobile: _buildMobileLayout(context, ref, themeMode),
      smallTablet: _buildTabletLayout(context, ref, themeMode),
      largeTablet: _buildLargeTabletLayout(context, ref, themeMode),
    );
  }

  /// 手机布局
  Widget _buildMobileLayout(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<ThemeMode> themeMode,
  ) {
    return Scaffold(
      body: ListView(
        children: [
          _buildSettingHeader(context, '设置'),
          _buildThemeItem(context, ref, themeMode),
          _buildSettingItem(
            context: context,
            icon: Icons.palette,
            title: '主题颜色',
            onTap: () => _showThemeDialog(context, ref),
          ),
          _buildSettingItem(
            context: context,
            icon: Icons.delete_outline,
            title: '清除缓存',
            onTap: () => _showClearCacheDialog(context),
          ),
          _buildSettingItem(
            context: context,
            icon: Icons.info,
            title: '关于',
            onTap: () => _showAboutDialog(context),
          ),
          _buildSettingItem(
            context: context,
            icon: Icons.exit_to_app,
            title: '退出登录',
            onTap: () => _showLogoutDialog(context),
          ),
        ],
      ),
    );
  }

  /// 平板布局
  Widget _buildTabletLayout(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<ThemeMode> themeMode,
  ) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSettingHeader(context, '设置'),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            children: [
              _buildThemeItem(context, ref, themeMode),
              _buildSettingItem(
                context: context,
                icon: Icons.palette,
                title: '主题颜色',
                onTap: () => _showThemeDialog(context, ref),
              ),
              _buildSettingItem(
                context: context,
                icon: Icons.delete_outline,
                title: '清除缓存',
                onTap: () => _showClearCacheDialog(context),
              ),
              _buildSettingItem(
                context: context,
                icon: Icons.info,
                title: '关于',
                onTap: () => _showAboutDialog(context),
              ),
              _buildSettingItem(
                context: context,
                icon: Icons.exit_to_app,
                title: '退出登录',
                onTap: () => _showLogoutDialog(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 大平板布局
  Widget _buildLargeTabletLayout(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<ThemeMode> themeMode,
  ) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSettingHeader(context, '设置'),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 3,
            children: [
              _buildThemeItem(context, ref, themeMode),
              _buildSettingItem(
                context: context,
                icon: Icons.palette,
                title: '主题颜色',
                onTap: () => _showThemeDialog(context, ref),
              ),
              _buildSettingItem(
                context: context,
                icon: Icons.delete_outline,
                title: '清除缓存',
                onTap: () => _showClearCacheDialog(context),
              ),
              _buildSettingItem(
                context: context,
                icon: Icons.info,
                title: '关于',
                onTap: () => _showAboutDialog(context),
              ),
              _buildSettingItem(
                context: context,
                icon: Icons.exit_to_app,
                title: '退出登录',
                onTap: () => _showLogoutDialog(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 设置头部
  Widget _buildSettingHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(title, style: Theme.of(context).textTheme.titleLarge),
    );
  }

  /// 设置项
  Widget _buildSettingItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  /// 主题项
  Widget _buildThemeItem(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<ThemeMode> themeMode,
  ) {
    String currentThemeName;
    final mode = themeMode.value ?? ThemeMode.system;
    switch (mode) {
      case ThemeMode.system:
        currentThemeName = '跟随系统';
      case ThemeMode.light:
        currentThemeName = '浅色模式';
      case ThemeMode.dark:
        currentThemeName = '深色模式';
    }
    return ListTile(
      leading: Icon(
        Icons.brightness_6,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: const Text('主题设置'),
      subtitle: Text(currentThemeName),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => _showThemeDialog(context, ref),
    );
  }

  /// 显示主题切换对话框
  void _showThemeDialog(BuildContext context, WidgetRef ref) {
    final currentMode = ref.read(themeModeProvider).value ?? ThemeMode.system;
    showDialog<void>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('选择主题'),
          children: [
            RadioGroup<ThemeMode>(
              groupValue: currentMode,
              onChanged: (value) {
                if (value != null) {
                  ref.read(themeModeProvider.notifier).change(value);
                }
                Navigator.pop(context);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile(
                    title: const Text('跟随系统'),
                    value: ThemeMode.system,
                  ),
                  RadioListTile(
                    title: const Text('浅色模式'),
                    value: ThemeMode.light,
                  ),
                  RadioListTile(
                    title: const Text('深色模式'),
                    value: ThemeMode.dark,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  /// 显示清除缓存确认对话框
  void _showClearCacheDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('清除缓存'),
          content: const Text('确定要清除所有缓存数据吗？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // TODO: 实际清除缓存逻辑
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('缓存已清除')));
              },
              child: const Text('确定'),
            ),
          ],
        );
      },
    );
  }

  /// 显示关于对话框
  void _showAboutDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('关于'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('玩Android客户端'),
              SizedBox(height: 8),
              Text('版本: 1.0.0'),
              SizedBox(height: 16),
              Text('基于Flutter开发'),
              SizedBox(height: 8),
              Text('© 2026 Your Name'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('确定'),
            ),
          ],
        );
      },
    );
  }

  /// 显示退出登录确认对话框
  void _showLogoutDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('退出登录'),
          content: const Text('确定要退出登录吗？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // TODO: 实际退出登录逻辑
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('已退出登录')));
              },
              child: const Text('确定'),
            ),
          ],
        );
      },
    );
  }
}
