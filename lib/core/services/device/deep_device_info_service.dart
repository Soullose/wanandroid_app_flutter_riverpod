import 'dart:async';

import 'package:wanandroid_app_flutter_riverpod/src/rust/api/device_info.dart'
    as rust;

/// 深度设备信息服务
///
/// 封装 Rust 侧 `device_info` 模块的调用，提供 Dart 友好的接口。
/// 所有采集函数都是 async 的，不会阻塞 UI 线程。
class DeepDeviceInfoService {
  static final DeepDeviceInfoService _instance =
      DeepDeviceInfoService._internal();
  factory DeepDeviceInfoService() => _instance;
  DeepDeviceInfoService._internal();

  /// 缓存的深度设备信息
  rust.DeepDeviceInfo? _cachedInfo;

  /// 一键采集全部深度设备信息
  Future<rust.DeepDeviceInfo> collectAll() async {
    _cachedInfo = await rust.collectDeepDeviceInfo();
    return _cachedInfo!;
  }

  /// 仅采集 CPU 信息
  Future<rust.CpuInfo> collectCpu() => rust.collectCpuInfoDeep();

  /// 仅采集内存信息
  Future<rust.MemoryInfo> collectMemory() => rust.collectMemoryInfoDeep();

  /// 仅采集系统信息
  Future<rust.DeepSystemInfo> collectSystem() =>
      rust.collectSystemInfoDeep();

  /// 仅采集磁盘信息
  Future<List<rust.DiskInfo>> collectDisks() =>
      rust.collectDisksInfoDeep();

  /// 仅采集网络接口信息
  Future<List<rust.NetworkInterfaceInfo>> collectNetwork() =>
      rust.collectNetworkInfoDeep();

  /// 获取缓存的深度设备信息（如未采集则返回 null）
  rust.DeepDeviceInfo? get cached => _cachedInfo;

  /// 清除缓存
  void clearCache() {
    _cachedInfo = null;
  }

  // ─── 便捷格式化方法 ─────────────────────────────────────

  /// 将 CPU 信息格式化为可读字符串
  String formatCpuInfo(rust.CpuInfo cpu) {
    final buffer = StringBuffer();
    buffer.writeln('CPU: ${cpu.brand}');
    buffer.writeln('架构: ${cpu.arch}');
    buffer.writeln('物理核心: ${cpu.physicalCoreCount ?? "未知"}');
    buffer.writeln('逻辑核心: ${cpu.logicalCoreCount}');
    buffer.writeln('主频: ${cpu.globalFrequencyMhz} MHz');
    buffer.writeln('使用率: ${cpu.globalUsagePercent}%');
    return buffer.toString();
  }

  /// 将内存信息格式化为可读字符串
  String formatMemoryInfo(rust.MemoryInfo mem) {
    return '内存: ${_bytesToHuman(mem.usedBytes)} / ${_bytesToHuman(mem.totalBytes)} '
        '(${mem.usagePercent}%)'
        '${mem.swapTotalBytes > BigInt.zero ? " · Swap: ${_bytesToHuman(mem.swapUsedBytes)} / ${_bytesToHuman(mem.swapTotalBytes)}" : ""}';
  }

  /// 将磁盘信息格式化为可读字符串
  String formatDiskInfo(List<rust.DiskInfo> disks) {
    return disks
        .map((d) =>
            '${d.mountPoint} (${d.diskType}): ${_bytesToHuman(d.totalBytes - d.availableBytes)} / ${_bytesToHuman(d.totalBytes)} (${d.usagePercent}%)')
        .join('\n');
  }

  String _bytesToHuman(BigInt bytes) {
    const units = ['B', 'KB', 'MB', 'GB', 'TB'];
    var size = bytes.toInt().toDouble();
    var unitIndex = 0;
    while (size >= 1024 && unitIndex < units.length - 1) {
      size /= 1024;
      unitIndex++;
    }
    return '${size.toStringAsFixed(1)} ${units[unitIndex]}';
  }
}
