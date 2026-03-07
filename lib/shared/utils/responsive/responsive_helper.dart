import 'package:flutter/material.dart';
import 'device_type.dart';

/// 响应式布局断点常量
class Breakpoints {
  Breakpoints._();

  /// 手机断点：小于此值为手机
  static const double mobile = 600;

  /// 小平板断点：大于等于此值为平板
  static const double smallTablet = 600;

  /// 大平板断点：大于此值为大平板
  static const double largeTablet = 840;
}

/// 响应式布局工具类
/// 用于根据屏幕宽度判断设备类型并提供响应式布局支持
class ResponsiveHelper {
  ResponsiveHelper._();

  /// 根据屏幕宽度获取设备类型
  static DeviceType getDeviceType(double width) {
    if (width < Breakpoints.mobile) {
      return DeviceType.mobile;
    } else if (width < Breakpoints.largeTablet) {
      return DeviceType.smallTablet;
    } else {
      return DeviceType.largeTablet;
    }
  }

  /// 从BuildContext获取设备类型
  static DeviceType getDeviceTypeFromContext(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return getDeviceType(width);
  }

  /// 获取屏幕宽度
  static double screenWidth(BuildContext context) {
    return MediaQuery.sizeOf(context).width;
  }

  /// 获取屏幕高度
  static double screenHeight(BuildContext context) {
    return MediaQuery.sizeOf(context).height;
  }

  /// 获取屏幕尺寸
  static Size screenSize(BuildContext context) {
    return MediaQuery.sizeOf(context);
  }

  /// 是否为手机设备
  static bool isMobile(BuildContext context) {
    return getDeviceTypeFromContext(context).isMobile;
  }

  /// 是否为平板设备
  static bool isTablet(BuildContext context) {
    return getDeviceTypeFromContext(context).isTablet;
  }

  /// 是否为小平板
  static bool isSmallTablet(BuildContext context) {
    return getDeviceTypeFromContext(context).isSmallTablet;
  }

  /// 是否为大平板
  static bool isLargeTablet(BuildContext context) {
    return getDeviceTypeFromContext(context).isLargeTablet;
  }

  /// 是否为横屏
  static bool isLandscape(BuildContext context) {
    return MediaQuery.orientationOf(context) == Orientation.landscape;
  }

  /// 是否为竖屏
  static bool isPortrait(BuildContext context) {
    return MediaQuery.orientationOf(context) == Orientation.portrait;
  }

  /// 根据设备类型返回不同的值
  static T valueByDevice<T>(
    BuildContext context, {
    required T mobile,
    T? smallTablet,
    T? largeTablet,
  }) {
    final deviceType = getDeviceTypeFromContext(context);
    switch (deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.smallTablet:
        return smallTablet ?? mobile;
      case DeviceType.largeTablet:
        return largeTablet ?? smallTablet ?? mobile;
    }
  }

  /// 根据屏幕宽度返回不同的值
  static T valueByWidth<T>(
    double width, {
    required T mobile,
    T? smallTablet,
    T? largeTablet,
  }) {
    final deviceType = getDeviceType(width);
    switch (deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.smallTablet:
        return smallTablet ?? mobile;
      case DeviceType.largeTablet:
        return largeTablet ?? smallTablet ?? mobile;
    }
  }

  /// 获取响应式网格列数
  static int gridCrossAxisCount(BuildContext context) {
    return valueByDevice(context, mobile: 1, smallTablet: 2, largeTablet: 3);
  }

  /// 获取响应式内边距
  static EdgeInsets responsivePadding(BuildContext context) {
    return valueByDevice(
      context,
      mobile: const EdgeInsets.all(16),
      smallTablet: const EdgeInsets.all(24),
      largeTablet: const EdgeInsets.all(32),
    );
  }

  /// 获取响应式列表项最大宽度
  static double? listItemMaxWidth(BuildContext context) {
    return valueByDevice<double?>(
      context,
      mobile: null,
      smallTablet: 600,
      largeTablet: 800,
    );
  }
}
