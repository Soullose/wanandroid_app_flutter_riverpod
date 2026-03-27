import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'network_status.dart';

part 'network_status_provider.g.dart';

/// 网络状态 Provider
@riverpod
class NetworkStatusNotifier extends _$NetworkStatusNotifier {
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  final Connectivity _connectivity = Connectivity();

  @override
  NetworkStatus build() {
    // 启动时立即检测网络状态
    _checkConnectivity();
    // 监听网络状态变化
    _listenConnectivity();
    // 组件销毁时取消订阅
    ref.onDispose(() {
      _subscription?.cancel();
    });

    return NetworkStatus.unknown;
  }

  /// 检测网络连接状态
  Future<void> _checkConnectivity() async {
    try {
      final results = await _connectivity.checkConnectivity();
      await _updateStatus(results);
    } catch (e) {
      state = NetworkStatus.offline;
    }
  }

  /// 监听网络状态变化
  void _listenConnectivity() {
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      _updateStatus(results);
    });
  }

  /// 更新网络状态
  Future<void> _updateStatus(List<ConnectivityResult> results) async {
    final connectionType = _getConnectionType(results);
    final isOnline = await _isOnline(results);

    state = NetworkStatus(
      status: isOnline
          ? NetworkConnectionStatus.online
          : NetworkConnectionStatus.offline,
      connectionType: connectionType,
    );
  }

  /// 获取连接类型
  String _getConnectionType(List<ConnectivityResult> results) {
    if (results.isEmpty || results.contains(ConnectivityResult.none)) {
      return 'None';
    }

    if (results.contains(ConnectivityResult.wifi)) {
      return 'WiFi';
    }

    if (results.contains(ConnectivityResult.mobile)) {
      return 'Mobile';
    }

    if (results.contains(ConnectivityResult.ethernet)) {
      return 'Ethernet';
    }

    if (results.contains(ConnectivityResult.bluetooth)) {
      return 'Bluetooth';
    }

    if (results.contains(ConnectivityResult.vpn)) {
      return 'VPN';
    }

    return 'Unknown';
  }

  /// 检查是否真正在线（通过DNS查询验证）
  Future<bool> _isOnline(List<ConnectivityResult> results) async {
    // 如果没有连接类型或连接类型为 none，则离线
    if (results.isEmpty || results.contains(ConnectivityResult.none)) {
      return false;
    }

    // 尝试连接到公共 DNS 来验证网络是否真正可用
    try {
      // 使用国内可访问的地址进行检测
      final result = await InternetAddress.lookup(
        'www.baidu.com',
      ).timeout(const Duration(seconds: 3));
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    } on TimeoutException catch (_) {
      return false;
    } catch (_) {
      // 如果 DNS 查询失败，仍然根据连接类型判断
      return results.isNotEmpty && !results.contains(ConnectivityResult.none);
    }
  }

  /// 手动刷新网络状态（供外部调用）
  Future<void> refresh() async {
    await _checkConnectivity();
  }
}
