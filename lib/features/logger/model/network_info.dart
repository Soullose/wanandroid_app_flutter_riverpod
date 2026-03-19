import 'package:freezed_annotation/freezed_annotation.dart';

part 'network_info.freezed.dart';
part 'network_info.g.dart';

/// 网络信息模型
@freezed
sealed class NetworkInfo with _$NetworkInfo {
  const factory NetworkInfo({
    /// 连接类型（WiFi、Mobile、Ethernet、None）
    required String connectionType,

    /// 是否在线
    required bool isOnline,

    /// 网络运营商（可选）
    String? carrier,

    /// WiFi名称（可选，仅iOS支持）
    String? wifiName,

    /// WiFi BSSID（可选）
    String? wifiBSSID,

    /// WiFi IP地址（可选）
    String? wifiIP,

    /// 移动网络信号强度（可选）
    String? mobileSignalStrength,
  }) = _NetworkInfo;

  factory NetworkInfo.fromJson(Map<String, dynamic> json) =>
      _$NetworkInfoFromJson(json);
}
