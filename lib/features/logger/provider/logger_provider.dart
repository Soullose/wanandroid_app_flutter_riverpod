import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wanandroid_app_flutter_riverpod/core/services/logger/file_logger_service.dart';
import 'package:wanandroid_app_flutter_riverpod/features/logger/model/log_entry.dart';
import 'package:wanandroid_app_flutter_riverpod/features/logger/model/log_level.dart';

part 'logger_provider.g.dart';

/// 文件日志服务 Provider
@riverpod
FileLoggerService fileLoggerService(Ref ref) {
  return FileLoggerService();
}

/// 日志条目列表 Provider
@riverpod
class LogEntries extends _$LogEntries {
  @override
  Future<List<LogEntry>> build() async {
    final service = ref.watch(fileLoggerServiceProvider);
    return service.getLogEntries();
  }

  /// 刷新日志列表
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(fileLoggerServiceProvider);
      return service.getLogEntries();
    });
  }

  /// 删除单个日志
  Future<void> deleteLog(LogEntry entry) async {
    final service = ref.read(fileLoggerServiceProvider);
    await service.deleteLog(entry);
    await refresh();
  }

  /// 删除多个日志
  Future<void> deleteLogs(List<LogEntry> entries) async {
    final service = ref.read(fileLoggerServiceProvider);
    await service.deleteLogs(entries);
    await refresh();
  }

  /// 删除所有日志
  Future<void> deleteAllLogs() async {
    final service = ref.read(fileLoggerServiceProvider);
    await service.deleteAllLogs();
    await refresh();
  }
}

/// 日志总大小 Provider
@riverpod
class TotalLogSize extends _$TotalLogSize {
  @override
  Future<int> build() async {
    final service = ref.watch(fileLoggerServiceProvider);
    return service.getTotalLogSize();
  }

  /// 刷新
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(fileLoggerServiceProvider);
      return service.getTotalLogSize();
    });
  }
}

/// 日志文件数量 Provider
@riverpod
class LogFileCount extends _$LogFileCount {
  @override
  Future<int> build() async {
    final service = ref.watch(fileLoggerServiceProvider);
    return service.getLogFileCount();
  }

  /// 刷新
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(fileLoggerServiceProvider);
      return service.getLogFileCount();
    });
  }
}

/// 清理建议 Provider
@riverpod
class CleanupRecommendationNotifier extends _$CleanupRecommendationNotifier {
  @override
  Future<CleanupRecommendation?> build() async {
    final service = ref.watch(fileLoggerServiceProvider);
    return service.checkCleanup();
  }

  /// 刷新
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(fileLoggerServiceProvider);
      return service.checkCleanup();
    });
  }

  /// 清理过期日志
  Future<int> cleanupOldLogs() async {
    final service = ref.read(fileLoggerServiceProvider);
    final count = await service.cleanupOldLogs();
    await refresh();
    return count;
  }
}

/// 日志筛选条件
class LogFilter {
  final LogLevel? level;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? searchQuery;

  const LogFilter({this.level, this.startDate, this.endDate, this.searchQuery});

  LogFilter copyWith({
    LogLevel? level,
    DateTime? startDate,
    DateTime? endDate,
    String? searchQuery,
    bool clearLevel = false,
    bool clearStartDate = false,
    bool clearEndDate = false,
    bool clearSearchQuery = false,
  }) {
    return LogFilter(
      level: clearLevel ? null : (level ?? this.level),
      startDate: clearStartDate ? null : (startDate ?? this.startDate),
      endDate: clearEndDate ? null : (endDate ?? this.endDate),
      searchQuery: clearSearchQuery ? null : (searchQuery ?? this.searchQuery),
    );
  }

  bool get hasFilter =>
      level != null ||
      startDate != null ||
      endDate != null ||
      (searchQuery != null && searchQuery!.isNotEmpty);
}

/// 筛选后的日志列表 Provider
@riverpod
class FilteredLogEntries extends _$FilteredLogEntries {
  @override
  Future<List<LogEntry>> build(LogFilter filter) async {
    final entries = await ref.watch(logEntriesProvider.future);
    return _applyFilter(entries, filter);
  }

  List<LogEntry> _applyFilter(List<LogEntry> entries, LogFilter filter) {
    var result = entries;

    // 按级别筛选
    if (filter.level != null) {
      result = result.where((e) => e.level == filter.level).toList();
    }

    // 按开始日期筛选
    if (filter.startDate != null) {
      result = result
          .where((e) => e.timestamp.isAfter(filter.startDate!))
          .toList();
    }

    // 按结束日期筛选
    if (filter.endDate != null) {
      result = result
          .where((e) => e.timestamp.isBefore(filter.endDate!))
          .toList();
    }

    // 按搜索关键词筛选
    if (filter.searchQuery != null && filter.searchQuery!.isNotEmpty) {
      final query = filter.searchQuery!.toLowerCase();
      result = result.where((e) {
        return e.message.toLowerCase().contains(query) ||
            (e.stackTrace?.toLowerCase().contains(query) ?? false) ||
            (e.errorType?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    return result;
  }
}
