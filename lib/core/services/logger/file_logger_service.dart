import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:wanandroid_app_flutter_riverpod/features/logger/model/device_info.dart';
import 'package:wanandroid_app_flutter_riverpod/features/logger/model/log_entry.dart';
import 'package:wanandroid_app_flutter_riverpod/features/logger/model/log_level.dart';
import 'package:wanandroid_app_flutter_riverpod/features/logger/model/network_info.dart';

import 'device_info_service.dart';
import 'network_info_service.dart';

/// 文件日志服务
class FileLoggerService {
  static final FileLoggerService _instance = FileLoggerService._internal();
  factory FileLoggerService() => _instance;
  FileLoggerService._internal();

  static const String _logDirectoryName = 'logs';
  static const int maxDays = 30;
  static const int maxSizeMB = 100;

  final Uuid _uuid = const Uuid();
  final DeviceInfoService _deviceInfoService = DeviceInfoService();
  final NetworkInfoService _networkInfoService = NetworkInfoService();

  Directory? _logDirectory;

  /// 初始化日志服务
  Future<void> initialize() async {
    _logDirectory = await _getLogDirectory();
    if (!await _logDirectory!.exists()) {
      await _logDirectory!.create(recursive: true);
    }

    if (kDebugMode) {
      print('Log directory: ${_logDirectory!.path}');
    }
  }

  /// 获取日志目录
  Future<Directory> _getLogDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    return Directory('${appDir.path}/$_logDirectoryName');
  }

  /// 记录错误日志
  Future<LogEntry> logError(
    dynamic error,
    StackTrace? stackTrace, {
    LogLevel level = LogLevel.error,
    Map<String, dynamic>? additionalData,
  }) async {
    if (_logDirectory == null) {
      await initialize();
    }

    final id = _uuid.v4();
    final timestamp = DateTime.now();

    // 收集设备信息和网络信息
    DeviceInfo? deviceInfo;
    NetworkInfo? networkInfo;

    try {
      deviceInfo = await _deviceInfoService.collectDeviceInfo();
    } catch (e) {
      if (kDebugMode) {
        print('Failed to collect device info: $e');
      }
    }

    try {
      networkInfo = await _networkInfoService.collectNetworkInfo();
    } catch (e) {
      if (kDebugMode) {
        print('Failed to collect network info: $e');
      }
    }

    final logEntry = LogEntry(
      id: id,
      timestamp: timestamp,
      level: level,
      message: error.toString(),
      stackTrace: stackTrace?.toString(),
      errorType: error.runtimeType.toString(),
      deviceInfo: deviceInfo,
      networkInfo: networkInfo,
      additionalData: additionalData,
    );

    // 生成日志文件名
    final fileName = _generateFileName(level, timestamp);
    final filePath = '${_logDirectory!.path}/$fileName';

    // 写入日志文件
    final logContent = _formatLogContent(logEntry);
    final file = File(filePath);
    await file.writeAsString(logContent);

    // 更新日志条目的文件信息
    final fileSize = await file.length();
    final updatedEntry = logEntry.copyWith(
      filePath: filePath,
      fileSize: fileSize,
    );

    if (kDebugMode) {
      print('Log saved to: $filePath');
    }

    return updatedEntry;
  }

  /// 生成日志文件名
  String _generateFileName(LogLevel level, DateTime timestamp) {
    final levelPrefix = level.name.toLowerCase();
    final dateStr = timestamp.toString().replaceAll(':', '-').split('.').first;
    return '${levelPrefix}_$dateStr.log';
  }

  /// 格式化日志内容
  String _formatLogContent(LogEntry entry) {
    final buffer = StringBuffer();

    buffer.writeln('=' * 80);
    buffer.writeln('[时间] ${_formatDateTime(entry.timestamp)}');
    buffer.writeln('[级别] ${entry.level.name}');
    buffer.writeln('[类型] ${entry.errorType ?? "Unknown"}');
    buffer.writeln('=' * 80);

    // 设备信息
    if (entry.deviceInfo != null) {
      buffer.writeln('\n[设备信息]');
      final device = entry.deviceInfo!;
      buffer.writeln('- 设备型号: ${device.deviceModel}');
      buffer.writeln('- 系统名称: ${device.systemName}');
      buffer.writeln('- 系统版本: ${device.systemVersion}');
      if (device.longOsVersion != null) {
        buffer.writeln('- 完整系统版本: ${device.longOsVersion}');
      }
      buffer.writeln('- CPU架构: ${device.cpuArch}');
      buffer.writeln('- 应用版本: ${device.appVersion}');
      buffer.writeln('- Dart版本: ${device.dartVersion}');
      if (device.deviceId != null) {
        buffer.writeln('- 设备ID: ${device.deviceId}');
      }
      if (device.brand != null) {
        buffer.writeln('- 品牌: ${device.brand}');
      }
      if (device.manufacturer != null) {
        buffer.writeln('- 制造商: ${device.manufacturer}');
      }
      buffer.writeln('- 物理设备: ${device.isPhysicalDevice ? "是" : "否"}');
    }

    // 网络信息
    if (entry.networkInfo != null) {
      buffer.writeln('\n[网络状态]');
      final network = entry.networkInfo!;
      buffer.writeln('- 连接类型: ${network.connectionType}');
      buffer.writeln('- 是否在线: ${network.isOnline ? "是" : "否"}');
    }

    // 错误信息
    buffer.writeln('\n[错误信息]');
    buffer.writeln(entry.message);

    // 堆栈跟踪
    if (entry.stackTrace != null && entry.stackTrace!.isNotEmpty) {
      buffer.writeln('\n[堆栈跟踪]');
      buffer.writeln(entry.stackTrace);
    }

    // 附加数据
    if (entry.additionalData != null && entry.additionalData!.isNotEmpty) {
      buffer.writeln('\n[附加数据]');
      buffer.writeln(
        const JsonEncoder.withIndent('  ').convert(entry.additionalData),
      );
    }

    buffer.writeln('\n' + '=' * 80);

    return buffer.toString();
  }

  /// 格式化日期时间
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}.${dateTime.millisecond.toString().padLeft(3, '0')}';
  }

  /// 获取所有日志条目
  Future<List<LogEntry>> getLogEntries() async {
    if (_logDirectory == null) {
      await initialize();
    }

    final entries = <LogEntry>[];
    final files = _logDirectory!.listSync().whereType<File>().toList();

    for (final file in files) {
      if (file.path.endsWith('.log')) {
        try {
          final entry = await _parseLogFile(file);
          entries.add(entry);
        } catch (e) {
          if (kDebugMode) {
            print('Failed to parse log file ${file.path}: $e');
          }
        }
      }
    }

    // 按时间戳降序排序
    entries.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return entries;
  }

  /// 解析日志文件
  Future<LogEntry> _parseLogFile(File file) async {
    final stat = await file.stat();
    final fileName = file.uri.pathSegments.last;
    final content = await file.readAsString();

    // 从文件名解析级别和时间
    final parts = fileName.replaceAll('.log', '').split('_');
    final level = LogLevel.fromString(parts.first);

    // 解析时间戳
    DateTime timestamp;
    try {
      final dateStr = parts.sublist(1).join('_');
      timestamp = DateTime.parse(dateStr.replaceAll('-', ':'));
    } catch (_) {
      timestamp = stat.modified;
    }

    // 解析内容
    String? message;
    String? stackTrace;
    String? errorType;

    final lines = content.split('\n');
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      if (line.startsWith('[类型]')) {
        errorType = line.substring(4).trim();
      } else if (line.startsWith('[错误信息]')) {
        // 读取错误信息直到下一个标签
        final messageLines = <String>[];
        for (int j = i + 1; j < lines.length; j++) {
          if (lines[j].startsWith('[') || lines[j].startsWith('=')) {
            break;
          }
          messageLines.add(lines[j]);
        }
        message = messageLines.join('\n').trim();
      } else if (line.startsWith('[堆栈跟踪]')) {
        // 读取堆栈跟踪直到下一个标签
        final stackLines = <String>[];
        for (int j = i + 1; j < lines.length; j++) {
          if (lines[j].startsWith('[') || lines[j].startsWith('=')) {
            break;
          }
          stackLines.add(lines[j]);
        }
        stackTrace = stackLines.join('\n').trim();
      }
    }

    return LogEntry(
      id: fileName.hashCode.toString(),
      timestamp: timestamp,
      level: level,
      message: message ?? 'Unknown error',
      stackTrace: stackTrace,
      errorType: errorType,
      filePath: file.path,
      fileSize: stat.size,
    );
  }

  /// 获取日志总大小（字节）
  Future<int> getTotalLogSize() async {
    if (_logDirectory == null) {
      await initialize();
    }

    int totalSize = 0;
    final files = _logDirectory!.listSync().whereType<File>().toList();

    for (final file in files) {
      if (file.path.endsWith('.log')) {
        totalSize += await file.length();
      }
    }

    return totalSize;
  }

  /// 获取日志文件数量
  Future<int> getLogFileCount() async {
    if (_logDirectory == null) {
      await initialize();
    }

    return _logDirectory!
        .listSync()
        .whereType<File>()
        .where((file) => file.path.endsWith('.log'))
        .length;
  }

  /// 导出日志内容
  Future<String> exportLog(LogEntry entry) async {
    if (entry.filePath != null) {
      final file = File(entry.filePath!);
      if (await file.exists()) {
        return await file.readAsString();
      }
    }
    return _formatLogContent(entry);
  }

  /// 删除单个日志
  Future<void> deleteLog(LogEntry entry) async {
    if (entry.filePath != null) {
      final file = File(entry.filePath!);
      if (await file.exists()) {
        await file.delete();
      }
    }
  }

  /// 删除多个日志
  Future<void> deleteLogs(List<LogEntry> entries) async {
    for (final entry in entries) {
      await deleteLog(entry);
    }
  }

  /// 删除所有日志
  Future<void> deleteAllLogs() async {
    if (_logDirectory == null) {
      await initialize();
    }

    final files = _logDirectory!.listSync().whereType<File>().toList();
    for (final file in files) {
      if (file.path.endsWith('.log')) {
        await file.delete();
      }
    }
  }

  /// 检查并返回清理建议
  Future<CleanupRecommendation?> checkCleanup() async {
    final entries = await getLogEntries();
    final totalSize = await getTotalLogSize();
    final sizeMB = totalSize / (1024 * 1024);

    // 检查过期日志
    final now = DateTime.now();
    final oldEntries = entries
        .where((e) => now.difference(e.timestamp).inDays > maxDays)
        .toList();

    // 判断是否需要清理
    final needsCleanup = oldEntries.isNotEmpty || sizeMB > maxSizeMB;

    if (needsCleanup) {
      String reason;
      if (oldEntries.isNotEmpty && sizeMB > maxSizeMB) {
        reason =
            '有${oldEntries.length}条日志超过$maxDays天，且日志总大小已超过${sizeMB.toStringAsFixed(1)}MB';
      } else if (oldEntries.isNotEmpty) {
        reason = '有${oldEntries.length}条日志超过$maxDays天';
      } else {
        reason = '日志总大小已超过${sizeMB.toStringAsFixed(1)}MB';
      }

      return CleanupRecommendation(
        oldEntriesCount: oldEntries.length,
        totalSizeMB: sizeMB,
        needsCleanup: true,
        reason: reason,
      );
    }

    return null;
  }

  /// 清理过期日志
  Future<int> cleanupOldLogs() async {
    final entries = await getLogEntries();
    final now = DateTime.now();
    int deletedCount = 0;

    for (final entry in entries) {
      if (now.difference(entry.timestamp).inDays > maxDays) {
        await deleteLog(entry);
        deletedCount++;
      }
    }

    return deletedCount;
  }
}
