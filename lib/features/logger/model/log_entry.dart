import 'package:freezed_annotation/freezed_annotation.dart';

import 'device_info.dart';
import 'log_level.dart';
import 'network_info.dart';

part 'log_entry.freezed.dart';
part 'log_entry.g.dart';

/// 日志条目模型
@freezed
sealed class LogEntry with _$LogEntry {
  const factory LogEntry({
    /// 唯一标识符
    required String id,

    /// 时间戳
    required DateTime timestamp,

    /// 日志级别
    required LogLevel level,

    /// 错误信息/消息内容
    required String message,

    /// 堆栈跟踪（可选）
    String? stackTrace,

    /// 错误类型（可选）
    String? errorType,

    /// 设备信息（可选）
    DeviceInfo? deviceInfo,

    /// 网络信息（可选）
    NetworkInfo? networkInfo,

    /// 日志文件路径
    String? filePath,

    /// 文件大小（字节）
    int? fileSize,

    /// 附加数据（JSON格式）
    Map<String, dynamic>? additionalData,
  }) = _LogEntry;

  factory LogEntry.fromJson(Map<String, dynamic> json) =>
      _$LogEntryFromJson(json);
}

/// 日志清理建议
@freezed
sealed class CleanupRecommendation with _$CleanupRecommendation {
  const factory CleanupRecommendation({
    /// 过期日志数量（超过30天）
    required int oldEntriesCount,

    /// 日志总大小（MB）
    required double totalSizeMB,

    /// 是否需要清理
    required bool needsCleanup,

    /// 清理原因描述
    required String reason,
  }) = _CleanupRecommendation;

  factory CleanupRecommendation.fromJson(Map<String, dynamic> json) =>
      _$CleanupRecommendationFromJson(json);
}
