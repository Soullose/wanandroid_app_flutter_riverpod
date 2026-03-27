import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../common/router/router_path.dart';
import '../../core/services/network/network_status.dart';
import '../../core/services/network/network_status_provider.dart';

/// 网络错误提示页面
class NetworkErrorPage extends ConsumerStatefulWidget {
  const NetworkErrorPage({super.key});

  @override
  ConsumerState<NetworkErrorPage> createState() => _NetworkErrorPageState();
}

class _NetworkErrorPageState extends ConsumerState<NetworkErrorPage> {
  bool _isRetrying = false;

  Future<void> _onRetry() async {
    if (_isRetrying) return;

    setState(() {
      _isRetrying = true;
    });

    try {
      await ref.read(networkStatusProvider.notifier).refresh();

      // 延迟一小段时间让用户看到加载状态
      await Future<void>.delayed(const Duration(milliseconds: 500));

      // 检查网络状态，如果已恢复则跳转
      final status = ref.read(networkStatusProvider);
      if (status.isOnline && mounted) {
        context.go(RouterPath.home.path);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isRetrying = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // 监听网络状态
    ref.listen<NetworkStatus>(networkStatusProvider, (previous, next) {
      if (previous?.isOffline == true && next.isOnline) {
        context.go(RouterPath.home.path);
      }
    });

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 无网络图标
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.wifi_off_rounded,
                    size: 64,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 32),

                // 标题
                Text(
                  '网络不可用',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),

                // 描述
                Text(
                  '请检查您的网络连接后重试',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),

                // 重试按钮
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton.icon(
                    onPressed: _isRetrying ? null : _onRetry,
                    icon: _isRetrying
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: colorScheme.onPrimary,
                            ),
                          )
                        : const Icon(Icons.refresh_rounded),
                    label: Text(_isRetrying ? '正在检测...' : '重试'),
                  ),
                ),
                const SizedBox(height: 16),

                // 提示文字
                Text(
                  '网络恢复后将自动进入应用',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
