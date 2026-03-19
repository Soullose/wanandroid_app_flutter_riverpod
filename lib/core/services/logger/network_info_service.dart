import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:wanandroid_app_flutter_riverpod/features/logger/model/network_info.dart';

/// 网络信息收集服务
class NetworkInfoService {
  static final NetworkInfoService _instance = NetworkInfoService._internal();
  factory NetworkInfoService() => _instance;
  NetworkInfoService._internal();

  final Connectivity _connectivity = Connectivity();

  /// 获取网络信息
  Future<NetworkInfo> collectNetworkInfo() async {
    try {
      final connectivityResults = await _connectivity.checkConnectivity();
      final connectionType = _getConnectionType(connectivityResults);
      final isOnline = await _isOnline(connectivityResults);

      return NetworkInfo(connectionType: connectionType, isOnline: isOnline);
    } catch (e) {
      return NetworkInfo(connectionType: 'Unknown', isOnline: false);
    }
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

  /// 检查是否在线
  Future<bool> _isOnline(List<ConnectivityResult> results) async {
    if (results.isEmpty || results.contains(ConnectivityResult.none)) {
      return false;
    }

    // 尝试连接到一个公共DNS来验证网络是否真正可用
    try {
      final result = await InternetAddress.lookup(
        'google.com',
      ).timeout(const Duration(seconds: 3));
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    } catch (_) {
      // 如果DNS查询失败，仍然根据连接类型判断
      return results.isNotEmpty && !results.contains(ConnectivityResult.none);
    }
  }

  /// 监听网络状态变化
  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged;
}
