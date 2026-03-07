/// 设备类型枚举
/// 用于响应式布局断点判断
enum DeviceType {
  /// 手机：< 600dp
  mobile,

  /// 小平板：600dp - 840dp
  smallTablet,

  /// 大平板：> 840dp
  largeTablet,
}

/// 设备类型扩展方法
extension DeviceTypeExtension on DeviceType {
  /// 是否为手机设备
  bool get isMobile => this == DeviceType.mobile;

  /// 是否为平板设备（包括小平板和大平板）
  bool get isTablet =>
      this == DeviceType.smallTablet || this == DeviceType.largeTablet;

  /// 是否为小平板
  bool get isSmallTablet => this == DeviceType.smallTablet;

  /// 是否为大平板
  bool get isLargeTablet => this == DeviceType.largeTablet;

  /// 获取设备类型描述
  String get description {
    switch (this) {
      case DeviceType.mobile:
        return '手机';
      case DeviceType.smallTablet:
        return '小平板';
      case DeviceType.largeTablet:
        return '大平板';
    }
  }
}
