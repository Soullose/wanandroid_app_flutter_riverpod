/// 日志级别枚举
enum LogLevel {
  /// 调试信息
  debug('DEBUG', '调试', 0),

  /// 一般信息
  info('INFO', '信息', 1),

  /// 警告
  warning('WARNING', '警告', 2),

  /// 错误
  error('ERROR', '错误', 3),

  /// 严重错误/崩溃
  crash('CRASH', '崩溃', 4);

  const LogLevel(this.name, this.label, this.severity);

  /// 级别名称（英文）
  final String name;

  /// 级别标签（中文）
  final String label;

  /// 严重程度（数值越大越严重）
  final int severity;

  /// 从字符串解析日志级别
  static LogLevel fromString(String value) {
    return LogLevel.values.firstWhere(
      (level) => level.name.toUpperCase() == value.toUpperCase(),
      orElse: () => LogLevel.info,
    );
  }
}
