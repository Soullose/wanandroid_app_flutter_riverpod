import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/network/network_status.dart';
import '../../../core/services/network/network_status_provider.dart';
import 'network_status_banner.dart';

/// 网络状态感知包装器
///
/// 包装应用内容，在顶部显示网络状态横幅
/// 支持全局监听网络状态变化，并在状态变化时显示/隐藏横幅
class NetworkAwareWrapper extends ConsumerStatefulWidget {
  /// 子组件（通常是整个应用的路由内容）
  final Widget child;

  const NetworkAwareWrapper({required this.child, super.key});

  @override
  ConsumerState<NetworkAwareWrapper> createState() =>
      _NetworkAwareWrapperState();
}

class _NetworkAwareWrapperState extends ConsumerState<NetworkAwareWrapper> {
  /// 是否正在重试
  bool _isRetrying = false;

  /// 是否显示横幅
  bool _showBanner = false;

  /// 上一次的网络状态
  NetworkStatus? _previousStatus;

  /// 网络恢复后自动隐藏的定时器
  Timer? _autoHideTimer;

  @override
  void dispose() {
    _autoHideTimer?.cancel();
    super.dispose();
  }

  /// 处理重试操作
  Future<void> _handleRetry() async {
    if (_isRetrying) return;

    setState(() {
      _isRetrying = true;
    });

    try {
      await ref.read(networkStatusProvider.notifier).refresh();

      // 短暂延迟让用户看到加载状态
      await Future<void>.delayed(const Duration(milliseconds: 500));
    } finally {
      if (mounted) {
        setState(() {
          _isRetrying = false;
        });
      }
    }
  }

  /// 处理网络状态变化
  void _handleNetworkStatusChange(NetworkStatus? previous, NetworkStatus next) {
    // 取消之前的自动隐藏定时器
    _autoHideTimer?.cancel();
    _autoHideTimer = null;

    if (next.isOffline) {
      // 离线状态：显示横幅
      setState(() {
        _showBanner = true;
      });
    } else if (next.isOnline) {
      // 在线状态
      if (previous?.isOffline == true) {
        // 从离线恢复：显示成功提示，然后自动隐藏
        setState(() {
          _showBanner = true;
        });

        _autoHideTimer = Timer(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _showBanner = false;
            });
          }
        });
      } else {
        // 一直是在线状态：隐藏横幅
        setState(() {
          _showBanner = false;
        });
      }
    } else if (next.isUnknown) {
      // 未知状态：如果之前是离线，保持显示横幅
      if (_previousStatus?.isOffline == true) {
        setState(() {
          _showBanner = true;
        });
      }
    }

    _previousStatus = next;
  }

  @override
  Widget build(BuildContext context) {
    // 监听网络状态变化
    ref.listen<NetworkStatus>(
      networkStatusProvider,
      _handleNetworkStatusChange,
    );

    final currentStatus = ref.watch(networkStatusProvider);

    return Column(
      children: [
        // 网络状态横幅（使用AnimatedSize实现平滑的高度变化）
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          alignment: Alignment.topCenter,
          child: _showBanner
              ? AnimatedNetworkStatusBanner(
                  visible: _showBanner,
                  status: currentStatus,
                  onRetry: _handleRetry,
                  isRetrying: _isRetrying,
                )
              : const SizedBox.shrink(),
        ),
        // 主内容区域
        Expanded(child: widget.child),
      ],
    );
  }
}

/// 网络状态横幅的显示模式
enum NetworkBannerMode {
  /// 始终显示
  always,

  /// 仅在离线时显示
  offlineOnly,

  /// 仅在状态变化时短暂显示
  onChange,

  /// 从不显示
  never,
}
