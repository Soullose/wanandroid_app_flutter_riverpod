import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:wanandroid_app_flutter_riverpod/features/logger/model/device_info.dart';
import 'package:wanandroid_app_flutter_riverpod/src/rust/api/sysinfo.dart';

/// 设备信息收集服务
class DeviceInfoService {
  static final DeviceInfoService _instance = DeviceInfoService._internal();
  factory DeviceInfoService() => _instance;
  DeviceInfoService._internal();

  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  /// 缓存的设备信息
  DeviceInfo? _cachedDeviceInfo;

  /// 获取设备信息
  Future<DeviceInfo> collectDeviceInfo() async {
    if (_cachedDeviceInfo != null) {
      return _cachedDeviceInfo!;
    }

    try {
      final deviceInfo = await _collectDeviceInfo();
      _cachedDeviceInfo = deviceInfo;
      return deviceInfo;
    } catch (e) {
      // 如果收集失败，返回基本信息
      return DeviceInfo(
        deviceModel: 'Unknown',
        systemName: Platform.operatingSystem,
        systemVersion: Platform.operatingSystemVersion,
        cpuArch: cpuArch(),
        appVersion: '1.0.0+1',
        dartVersion: Platform.version.split(' ').first,
        isPhysicalDevice: true,
      );
    }
  }

  Future<DeviceInfo> _collectDeviceInfo() async {
    final String cpuArchValue = cpuArch();
    final String systemNameValue = systemName();
    final String longOsVersionValue = longOsVersion();

    if (Platform.isAndroid) {
      return _collectAndroidDeviceInfo(
        cpuArchValue,
        systemNameValue,
        longOsVersionValue,
      );
    } else if (Platform.isIOS) {
      return _collectIosDeviceInfo(
        cpuArchValue,
        systemNameValue,
        longOsVersionValue,
      );
    } else if (kIsWeb) {
      return _collectWebDeviceInfo(
        cpuArchValue,
        systemNameValue,
        longOsVersionValue,
      );
    } else {
      // 其他平台（Windows、macOS、Linux）
      return _collectDesktopDeviceInfo(
        cpuArchValue,
        systemNameValue,
        longOsVersionValue,
      );
    }
  }

  Future<DeviceInfo> _collectAndroidDeviceInfo(
    String cpuArchValue,
    String systemNameValue,
    String longOsVersionValue,
  ) async {
    final androidInfo = await _deviceInfoPlugin.androidInfo;

    return DeviceInfo(
      deviceModel: '${androidInfo.manufacturer} ${androidInfo.model}',
      systemName: systemNameValue,
      systemVersion: 'Android ${androidInfo.version.release}',
      longOsVersion: longOsVersionValue,
      cpuArch: cpuArchValue,
      appVersion: _getAppVersion(),
      dartVersion: Platform.version.split(' ').first,
      deviceId: androidInfo.id,
      brand: androidInfo.brand,
      manufacturer: androidInfo.manufacturer,
      screenResolution: await _getScreenResolution(),
      isPhysicalDevice: androidInfo.isPhysicalDevice,
    );
  }

  Future<DeviceInfo> _collectIosDeviceInfo(
    String cpuArchValue,
    String systemNameValue,
    String longOsVersionValue,
  ) async {
    final iosInfo = await _deviceInfoPlugin.iosInfo;

    return DeviceInfo(
      deviceModel: iosInfo.model,
      systemName: systemNameValue,
      systemVersion: '${iosInfo.systemName} ${iosInfo.systemVersion}',
      longOsVersion: longOsVersionValue,
      cpuArch: cpuArchValue,
      appVersion: _getAppVersion(),
      dartVersion: Platform.version.split(' ').first,
      deviceId: iosInfo.identifierForVendor,
      brand: 'Apple',
      manufacturer: 'Apple',
      screenResolution: await _getScreenResolution(),
      isPhysicalDevice: iosInfo.isPhysicalDevice,
    );
  }

  Future<DeviceInfo> _collectWebDeviceInfo(
    String cpuArchValue,
    String systemNameValue,
    String longOsVersionValue,
  ) async {
    final webInfo = await _deviceInfoPlugin.webBrowserInfo;

    return DeviceInfo(
      deviceModel: webInfo.browserName.name,
      systemName: systemNameValue,
      systemVersion: webInfo.appVersion ?? 'Unknown',
      longOsVersion: longOsVersionValue,
      cpuArch: cpuArchValue,
      appVersion: _getAppVersion(),
      dartVersion: Platform.version.split(' ').first,
      deviceId: webInfo.vendor ?? 'Unknown',
      brand: webInfo.browserName.name,
      manufacturer: webInfo.vendor ?? 'Unknown',
      isPhysicalDevice: true,
    );
  }

  Future<DeviceInfo> _collectDesktopDeviceInfo(
    String cpuArchValue,
    String systemNameValue,
    String longOsVersionValue,
  ) async {
    return DeviceInfo(
      deviceModel: 'Desktop',
      systemName: systemNameValue,
      systemVersion: Platform.operatingSystemVersion,
      longOsVersion: longOsVersionValue,
      cpuArch: cpuArchValue,
      appVersion: _getAppVersion(),
      dartVersion: Platform.version.split(' ').first,
      screenResolution: await _getScreenResolution(),
      isPhysicalDevice: true,
    );
  }

  /// 获取应用版本（需要在外部配置）
  String _getAppVersion() {
    // 这里可以从 package_info_plus 获取，暂时返回默认值
    return '1.0.0+1';
  }

  /// 获取屏幕分辨率
  Future<String?> _getScreenResolution() async {
    try {
      // 这里需要从 WidgetsBinding 获取
      return null;
    } catch (e) {
      return null;
    }
  }

  /// 清除缓存
  void clearCache() {
    _cachedDeviceInfo = null;
  }
}
