import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_info.freezed.dart';
part 'device_info.g.dart';

/// 设备信息模型
@freezed
sealed class DeviceInfo with _$DeviceInfo {
  const factory DeviceInfo({
    /// 设备型号（如：Xiaomi 14）
    required String deviceModel,

    /// 系统名称（如：Android、iOS）
    required String systemName,

    /// 系统版本（如：Android 14、iOS 17.0）
    required String systemVersion,

    /// 完整系统版本信息
    String? longOsVersion,

    /// CPU架构（如：arm64-v8a）
    required String cpuArch,

    /// 应用版本（如：1.0.0+1）
    required String appVersion,

    /// Dart版本
    required String dartVersion,

    /// 设备唯一标识
    String? deviceId,

    /// 设备品牌
    String? brand,

    /// 设备制造商
    String? manufacturer,

    /// 屏幕分辨率
    String? screenResolution,

    /// 是否为物理设备
    required bool isPhysicalDevice,
  }) = _DeviceInfo;

  factory DeviceInfo.fromJson(Map<String, dynamic> json) =>
      _$DeviceInfoFromJson(json);
}
