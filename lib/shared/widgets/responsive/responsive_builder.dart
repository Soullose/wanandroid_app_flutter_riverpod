import 'package:flutter/material.dart';
import '../../utils/responsive/device_type.dart';
import '../../utils/responsive/responsive_helper.dart';

/// 响应式布局构建器
/// 根据设备类型返回不同的布局
class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.smallTablet,
    this.largeTablet,
  });

  /// 手机布局（必需）
  final Widget mobile;

  /// 小平板布局（可选，默认使用mobile）
  final Widget? smallTablet;

  /// 大平板布局（可选，默认使用smallTablet或mobile）
  final Widget? largeTablet;

  @override
  Widget build(BuildContext context) {
    final deviceType = ResponsiveHelper.getDeviceTypeFromContext(context);

    switch (deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.smallTablet:
        return smallTablet ?? mobile;
      case DeviceType.largeTablet:
        return largeTablet ?? smallTablet ?? mobile;
    }
  }
}

/// 响应式布局构建器（带设备类型参数）
/// 提供更灵活的构建方式
class ResponsiveLayoutBuilder extends StatelessWidget {
  const ResponsiveLayoutBuilder({super.key, required this.builder});

  /// 构建函数，接收context和设备类型
  final Widget Function(BuildContext context, DeviceType deviceType) builder;

  @override
  Widget build(BuildContext context) {
    final deviceType = ResponsiveHelper.getDeviceTypeFromContext(context);
    return builder(context, deviceType);
  }
}

/// 响应式值选择器
/// 根据设备类型返回不同的值
class ResponsiveValue<T> extends StatelessWidget {
  const ResponsiveValue({
    super.key,
    required this.mobile,
    this.smallTablet,
    this.largeTablet,
    required this.builder,
  });

  /// 手机值（必需）
  final T mobile;

  /// 小平板值（可选）
  final T? smallTablet;

  /// 大平板值（可选）
  final T? largeTablet;

  /// 值构建器
  final Widget Function(BuildContext context, T value) builder;

  @override
  Widget build(BuildContext context) {
    final value = ResponsiveHelper.valueByDevice<T>(
      context,
      mobile: mobile,
      smallTablet: smallTablet,
      largeTablet: largeTablet,
    );
    return builder(context, value);
  }
}

/// 响应式Sliver布局构建器
/// 用于CustomScrollView中的Sliver组件
class ResponsiveSliverBuilder extends StatelessWidget {
  const ResponsiveSliverBuilder({
    super.key,
    required this.mobile,
    this.smallTablet,
    this.largeTablet,
  });

  /// 手机布局（必需）
  final Widget mobile;

  /// 小平板布局（可选）
  final Widget? smallTablet;

  /// 大平板布局（可选）
  final Widget? largeTablet;

  @override
  Widget build(BuildContext context) {
    final deviceType = ResponsiveHelper.getDeviceTypeFromContext(context);

    switch (deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.smallTablet:
        return smallTablet ?? mobile;
      case DeviceType.largeTablet:
        return largeTablet ?? smallTablet ?? mobile;
    }
  }
}
