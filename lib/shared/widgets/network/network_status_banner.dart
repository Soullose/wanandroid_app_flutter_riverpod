import 'package:flutter/material.dart';

import '../../../core/services/network/network_status.dart';

/// 网络状态横幅组件
///
/// 显示在网络状态变化时的顶部提示横幅
class NetworkStatusBanner extends StatelessWidget {
  /// 当前网络状态
  final NetworkStatus status;

  /// 重试回调
  final VoidCallback? onRetry;

  /// 是否正在重试
  final bool isRetrying;

  const NetworkStatusBanner({
    required this.status,
    super.key,
    this.onRetry,
    this.isRetrying = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: _getBackgroundColor(colorScheme),
      elevation: 2,
      child: SafeArea(
        bottom: false,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // 状态图标
              if (isRetrying)
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getForegroundColor(colorScheme),
                    ),
                  ),
                )
              else
                Icon(
                  _getIcon(),
                  size: 20,
                  color: _getForegroundColor(colorScheme),
                ),
              const SizedBox(width: 12),

              // 状态文本
              Expanded(
                child: Text(
                  _getMessage(),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: _getForegroundColor(colorScheme),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              // 重试按钮（仅离线状态显示）
              if (status.isOffline && onRetry != null)
                TextButton.icon(
                  onPressed: isRetrying ? null : onRetry,
                  icon: isRetrying
                      ? const SizedBox.shrink()
                      : Icon(
                          Icons.refresh_rounded,
                          size: 18,
                          color: _getForegroundColor(colorScheme),
                        ),
                  label: Text(
                    '重试',
                    style: TextStyle(
                      color: _getForegroundColor(colorScheme),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// 获取背景颜色
  Color _getBackgroundColor(ColorScheme colorScheme) {
    switch (status.status) {
      case NetworkConnectionStatus.online:
        return colorScheme.primaryContainer;
      case NetworkConnectionStatus.offline:
        return colorScheme.error;
      case NetworkConnectionStatus.unknown:
        return colorScheme.surfaceContainerHighest;
    }
  }

  /// 获取前景颜色
  Color _getForegroundColor(ColorScheme colorScheme) {
    switch (status.status) {
      case NetworkConnectionStatus.online:
        return colorScheme.onPrimaryContainer;
      case NetworkConnectionStatus.offline:
        return colorScheme.onError;
      case NetworkConnectionStatus.unknown:
        return colorScheme.onSurfaceVariant;
    }
  }

  /// 获取图标
  IconData _getIcon() {
    switch (status.status) {
      case NetworkConnectionStatus.online:
        return Icons.wifi_rounded;
      case NetworkConnectionStatus.offline:
        return Icons.wifi_off_rounded;
      case NetworkConnectionStatus.unknown:
        return Icons.sync_rounded;
    }
  }

  /// 获取消息文本
  String _getMessage() {
    switch (status.status) {
      case NetworkConnectionStatus.online:
        return '网络已恢复';
      case NetworkConnectionStatus.offline:
        return '网络不可用，请检查网络连接';
      case NetworkConnectionStatus.unknown:
        return '正在检测网络...';
    }
  }
}

/// 网络状态横幅动画包装器
///
/// 用于控制横幅的显示/隐藏动画
class AnimatedNetworkStatusBanner extends StatelessWidget {
  /// 是否显示横幅
  final bool visible;

  /// 当前网络状态
  final NetworkStatus status;

  /// 重试回调
  final VoidCallback? onRetry;

  /// 是否正在重试
  final bool isRetrying;

  const AnimatedNetworkStatusBanner({
    required this.visible,
    required this.status,
    super.key,
    this.onRetry,
    this.isRetrying = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      offset: visible ? Offset.zero : const Offset(0, -1),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      child: NetworkStatusBanner(
        status: status,
        onRetry: onRetry,
        isRetrying: isRetrying,
      ),
    );
  }
}
