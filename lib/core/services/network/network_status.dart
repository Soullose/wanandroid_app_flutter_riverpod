import 'package:freezed_annotation/freezed_annotation.dart';

part 'network_status.freezed.dart';

/// 网络连接状态枚举
enum NetworkConnectionStatus {
  /// 在线- 有网络连接
  online,

  /// 离线- 无网络连接
  offline,

  /// 未知- 正在检测中
  unknown,
}

/// 网络状态数据类
@freezed
sealed class NetworkStatus with _$NetworkStatus {
  const NetworkStatus._();

  const factory NetworkStatus({
    required NetworkConnectionStatus status,
    @Default('Unknown') String connectionType,
  }) = _NetworkStatus;

  /// 是否在线
  bool get isOnline => status == NetworkConnectionStatus.online;

  /// 是否离线
  bool get isOffline => status == NetworkConnectionStatus.offline;

  /// 是否未知状态
  bool get isUnknown => status == NetworkConnectionStatus.unknown;

  /// 未知状态实例
  static const NetworkStatus unknown = NetworkStatus(
    status: NetworkConnectionStatus.unknown,
  );

  /// 离线状态实例
  static const NetworkStatus offline = NetworkStatus(
    status: NetworkConnectionStatus.offline,
    connectionType: 'None',
  );
}
