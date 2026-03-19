import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wanandroid_app_flutter_riverpod/features/logger/model/log_entry.dart';
import 'package:wanandroid_app_flutter_riverpod/features/logger/model/log_level.dart';
import 'package:wanandroid_app_flutter_riverpod/features/logger/provider/logger_provider.dart';

/// 日志详情页面
class LogDetailPage extends ConsumerStatefulWidget {
  final LogEntry entry;

  const LogDetailPage({super.key, required this.entry});

  @override
  ConsumerState<LogDetailPage> createState() => _LogDetailPageState();
}

class _LogDetailPageState extends ConsumerState<LogDetailPage> {
  String? _fullContent;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFullContent();
  }

  Future<void> _loadFullContent() async {
    final service = ref.read(fileLoggerServiceProvider);
    try {
      final content = await service.exportLog(widget.entry);
      if (mounted) {
        setState(() {
          _fullContent = content;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('日志详情'),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: _copyContent,
            tooltip: '复制',
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareLog,
            tooltip: '分享',
          ),
          PopupMenuButton<String>(
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'delete',
                child: ListTile(
                  leading: Icon(Icons.delete, color: Colors.red),
                  title: Text('删除日志', style: TextStyle(color: Colors.red)),
                ),
              ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 基本信息
                  _buildInfoCard(theme),
                  const SizedBox(height: 16),

                  // 设备信息
                  if (widget.entry.deviceInfo != null) ...[
                    _buildDeviceInfoCard(theme),
                    const SizedBox(height: 16),
                  ],

                  // 网络信息
                  if (widget.entry.networkInfo != null) ...[
                    _buildNetworkInfoCard(theme),
                    const SizedBox(height: 16),
                  ],

                  // 错误信息
                  _buildErrorCard(theme),
                  const SizedBox(height: 16),

                  // 堆栈跟踪
                  if (widget.entry.stackTrace != null &&
                      widget.entry.stackTrace!.isNotEmpty) ...[
                    _buildStackTraceCard(theme),
                    const SizedBox(height: 16),
                  ],

                  // 完整日志
                  _buildFullLogCard(theme),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoCard(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('基本信息', style: theme.textTheme.titleMedium),
            const Divider(),
            _buildInfoRow(theme, '级别', widget.entry.level.label),
            _buildInfoRow(theme, '类型', widget.entry.errorType ?? 'Unknown'),
            _buildInfoRow(theme, '时间', _formatDateTime(widget.entry.timestamp)),
            if (widget.entry.fileSize != null)
              _buildInfoRow(theme, '大小', _formatSize(widget.entry.fileSize!)),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceInfoCard(ThemeData theme) {
    final device = widget.entry.deviceInfo!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('设备信息', style: theme.textTheme.titleMedium),
            const Divider(),
            _buildInfoRow(theme, '设备型号', device.deviceModel),
            _buildInfoRow(theme, '系统', device.systemName),
            _buildInfoRow(theme, '系统版本', device.systemVersion),
            if (device.longOsVersion != null)
              _buildInfoRow(theme, '完整版本', device.longOsVersion!),
            _buildInfoRow(theme, 'CPU架构', device.cpuArch),
            _buildInfoRow(theme, '应用版本', device.appVersion),
            _buildInfoRow(theme, 'Dart版本', device.dartVersion),
            if (device.brand != null) _buildInfoRow(theme, '品牌', device.brand!),
            if (device.manufacturer != null)
              _buildInfoRow(theme, '制造商', device.manufacturer!),
            _buildInfoRow(theme, '物理设备', device.isPhysicalDevice ? '是' : '否'),
          ],
        ),
      ),
    );
  }

  Widget _buildNetworkInfoCard(ThemeData theme) {
    final network = widget.entry.networkInfo!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('网络状态', style: theme.textTheme.titleMedium),
            const Divider(),
            _buildInfoRow(theme, '连接类型', network.connectionType),
            _buildInfoRow(theme, '是否在线', network.isOnline ? '是' : '否'),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorCard(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('错误信息', style: theme.textTheme.titleMedium),
            const Divider(),
            SelectableText(
              widget.entry.message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color:
                    widget.entry.level == LogLevel.crash ||
                        widget.entry.level == LogLevel.error
                    ? theme.colorScheme.error
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStackTraceCard(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('堆栈跟踪', style: theme.textTheme.titleMedium),
                TextButton.icon(
                  onPressed: () => _copyStackTrace(),
                  icon: const Icon(Icons.copy, size: 18),
                  label: const Text('复制'),
                ),
              ],
            ),
            const Divider(),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SelectableText(
                  widget.entry.stackTrace!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFullLogCard(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('完整日志', style: theme.textTheme.titleMedium),
                TextButton.icon(
                  onPressed: () => _copyFullLog(),
                  icon: const Icon(Icons.copy, size: 18),
                  label: const Text('复制'),
                ),
              ],
            ),
            const Divider(),
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxHeight: 400),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SingleChildScrollView(
                child: SelectableText(
                  _fullContent ?? '加载失败',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(ThemeData theme, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: SelectableText(value, style: theme.textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'delete':
        _deleteLog();
        break;
    }
  }

  Future<void> _copyContent() async {
    await Clipboard.setData(
      ClipboardData(text: _fullContent ?? widget.entry.message),
    );
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('日志内容已复制到剪贴板')));
    }
  }

  Future<void> _copyStackTrace() async {
    await Clipboard.setData(ClipboardData(text: widget.entry.stackTrace ?? ''));
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('堆栈跟踪已复制到剪贴板')));
    }
  }

  Future<void> _copyFullLog() async {
    await Clipboard.setData(ClipboardData(text: _fullContent ?? ''));
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('完整日志已复制到剪贴板')));
    }
  }

  Future<void> _shareLog() async {
    if (widget.entry.filePath != null &&
        File(widget.entry.filePath!).existsSync()) {
      await Share.shareXFiles([
        XFile(widget.entry.filePath!),
      ], subject: '日志文件 - ${widget.entry.level.label}');
    } else {
      await Share.share(
        _fullContent ?? widget.entry.message,
        subject: '日志内容 - ${widget.entry.level.label}',
      );
    }
  }

  Future<void> _deleteLog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除日志'),
        content: const Text('确定要删除这条日志吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('删除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await ref.read(logEntriesProvider.notifier).deleteLog(widget.entry);
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('日志已删除')));
    }
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
  }
}
