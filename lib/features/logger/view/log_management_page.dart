import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wanandroid_app_flutter_riverpod/features/logger/model/log_entry.dart';
import 'package:wanandroid_app_flutter_riverpod/features/logger/model/log_level.dart';
import 'package:wanandroid_app_flutter_riverpod/features/logger/provider/logger_provider.dart';

import 'log_detail_page.dart';

/// 日志管理页面
class LogManagementPage extends ConsumerStatefulWidget {
  const LogManagementPage({super.key});

  @override
  ConsumerState<LogManagementPage> createState() => _LogManagementPageState();
}

class _LogManagementPageState extends ConsumerState<LogManagementPage> {
  final TextEditingController _searchController = TextEditingController();
  LogFilter _currentFilter = const LogFilter();
  bool _isMultiSelectMode = false;
  final Set<String> _selectedLogIds = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final logEntries = ref.watch(logEntriesProvider);
    final totalSize = ref.watch(totalLogSizeProvider);
    final fileCount = ref.watch(logFileCountProvider);
    final cleanupRecommendation = ref.watch(cleanupRecommendationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('日志管理'),
        actions: [
          if (_isMultiSelectMode) ...[
            IconButton(
              icon: const Icon(Icons.select_all),
              onPressed: _selectAll,
              tooltip: '全选',
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _selectedLogIds.isNotEmpty ? _deleteSelected : null,
              tooltip: '删除选中',
            ),
          ] else ...[
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: _exportAllLogs,
              tooltip: '导出全部',
            ),
            PopupMenuButton<String>(
              onSelected: _handleMenuAction,
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'multi_select',
                  child: ListTile(
                    leading: Icon(Icons.checklist),
                    title: Text('多选模式'),
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete_all',
                  child: ListTile(
                    leading: Icon(Icons.delete_forever, color: Colors.red),
                    title: Text('清除全部日志', style: TextStyle(color: Colors.red)),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
      body: Column(
        children: [
          // 清理提示
          cleanupRecommendation.when(
            data: (recommendation) {
              if (recommendation == null || !recommendation.needsCleanup) {
                return const SizedBox.shrink();
              }
              return _buildCleanupBanner(theme, recommendation);
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),

          // 统计信息
          _buildStatsCard(theme, totalSize, fileCount),

          // 搜索和筛选
          _buildSearchAndFilter(theme),

          // 日志列表
          Expanded(child: _buildLogList(theme, logEntries)),
        ],
      ),
    );
  }

  Widget _buildCleanupBanner(
    ThemeData theme,
    CleanupRecommendation recommendation,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      color: theme.colorScheme.errorContainer,
      child: Row(
        children: [
          Icon(Icons.warning_amber, color: theme.colorScheme.onErrorContainer),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              recommendation.reason,
              style: TextStyle(color: theme.colorScheme.onErrorContainer),
            ),
          ),
          TextButton(
            onPressed: () => _showCleanupDialog(recommendation),
            child: const Text('立即清理'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(
    ThemeData theme,
    AsyncValue<int> totalSize,
    AsyncValue<int> fileCount,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            theme,
            Icons.description_outlined,
            '日志数量',
            fileCount.when(
              data: (count) => '$count 个',
              loading: () => '...',
              error: (_, __) => '-',
            ),
          ),
          Container(width: 1, height: 40, color: theme.dividerColor),
          _buildStatItem(
            theme,
            Icons.storage_outlined,
            '占用空间',
            totalSize.when(
              data: (size) => _formatSize(size),
              loading: () => '...',
              error: (_, __) => '-',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    ThemeData theme,
    IconData icon,
    String label,
    String value,
  ) {
    return Column(
      children: [
        Icon(icon, color: theme.colorScheme.primary),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchAndFilter(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // 搜索框
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: '搜索日志内容...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _updateFilter(searchQuery: '', clearSearchQuery: true);
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
            onChanged: (value) {
              _updateFilter(searchQuery: value);
            },
          ),
          const SizedBox(height: 8),

          // 筛选按钮
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('全部', null),
                const SizedBox(width: 8),
                ...LogLevel.values.map(
                  (level) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _buildFilterChip(level.label, level),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, LogLevel? level) {
    final isSelected = _currentFilter.level == level;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {
        setState(() {
          _currentFilter = _currentFilter.copyWith(
            level: level,
            clearLevel: level == null,
          );
        });
      },
    );
  }

  Widget _buildLogList(ThemeData theme, AsyncValue<List<LogEntry>> logEntries) {
    return logEntries.when(
      data: (entries) {
        // 应用筛选
        final filteredEntries = _applyFilter(entries);

        if (filteredEntries.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inbox_outlined,
                  size: 64,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 16),
                Text(
                  entries.isEmpty ? '暂无日志记录' : '没有匹配的日志',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => ref.read(logEntriesProvider.notifier).refresh(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredEntries.length,
            itemBuilder: (context, index) {
              final entry = filteredEntries[index];
              return _buildLogTile(theme, entry);
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('加载失败: $error')),
    );
  }

  Widget _buildLogTile(ThemeData theme, LogEntry entry) {
    final isSelected = _selectedLogIds.contains(entry.id);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: _isMultiSelectMode
            ? Checkbox(
                value: isSelected,
                onChanged: (_) => _toggleSelection(entry.id),
              )
            : _buildLevelIcon(theme, entry.level),
        title: Text(
          entry.message,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color:
                entry.level == LogLevel.crash || entry.level == LogLevel.error
                ? theme.colorScheme.error
                : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: _getLevelColor(theme, entry.level).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    entry.level.label,
                    style: TextStyle(
                      fontSize: 12,
                      color: _getLevelColor(theme, entry.level),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _formatDateTime(entry.timestamp),
                  style: theme.textTheme.bodySmall,
                ),
                if (entry.fileSize != null) ...[
                  const SizedBox(width: 8),
                  Text(
                    _formatSize(entry.fileSize!),
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ],
            ),
          ],
        ),
        trailing: _isMultiSelectMode ? null : const Icon(Icons.chevron_right),
        onTap: () {
          if (_isMultiSelectMode) {
            _toggleSelection(entry.id);
          } else {
            _navigateToDetail(entry);
          }
        },
        onLongPress: () {
          if (!_isMultiSelectMode) {
            _showLogOptions(entry);
          }
        },
      ),
    );
  }

  Widget _buildLevelIcon(ThemeData theme, LogLevel level) {
    final color = _getLevelColor(theme, level);
    final icon = _getLevelIcon(level);

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: color),
    );
  }

  Color _getLevelColor(ThemeData theme, LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return Colors.grey;
      case LogLevel.info:
        return theme.colorScheme.primary;
      case LogLevel.warning:
        return Colors.orange;
      case LogLevel.error:
        return theme.colorScheme.error;
      case LogLevel.crash:
        return Colors.red.shade900;
    }
  }

  IconData _getLevelIcon(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return Icons.bug_report;
      case LogLevel.info:
        return Icons.info_outline;
      case LogLevel.warning:
        return Icons.warning_amber;
      case LogLevel.error:
        return Icons.error_outline;
      case LogLevel.crash:
        return Icons.report_problem;
    }
  }

  List<LogEntry> _applyFilter(List<LogEntry> entries) {
    var result = entries;

    // 按级别筛选
    if (_currentFilter.level != null) {
      result = result.where((e) => e.level == _currentFilter.level).toList();
    }

    // 按搜索关键词筛选
    if (_currentFilter.searchQuery != null &&
        _currentFilter.searchQuery!.isNotEmpty) {
      final query = _currentFilter.searchQuery!.toLowerCase();
      result = result.where((e) {
        return e.message.toLowerCase().contains(query) ||
            (e.stackTrace?.toLowerCase().contains(query) ?? false) ||
            (e.errorType?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    return result;
  }

  void _updateFilter({String? searchQuery, bool clearSearchQuery = false}) {
    setState(() {
      _currentFilter = _currentFilter.copyWith(
        searchQuery: searchQuery,
        clearSearchQuery: clearSearchQuery,
      );
    });
  }

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedLogIds.contains(id)) {
        _selectedLogIds.remove(id);
      } else {
        _selectedLogIds.add(id);
      }
    });
  }

  void _selectAll() {
    final entries = ref.read(logEntriesProvider).value ?? [];
    setState(() {
      if (_selectedLogIds.length == entries.length) {
        _selectedLogIds.clear();
      } else {
        _selectedLogIds.clear();
        _selectedLogIds.addAll(entries.map((e) => e.id));
      }
    });
  }

  void _navigateToDetail(LogEntry entry) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LogDetailPage(entry: entry)),
    );
  }

  void _showLogOptions(LogEntry entry) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.visibility),
              title: const Text('查看详情'),
              onTap: () {
                Navigator.pop(context);
                _navigateToDetail(entry);
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('复制内容'),
              onTap: () {
                Navigator.pop(context);
                _copyLogContent(entry);
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('分享日志'),
              onTap: () {
                Navigator.pop(context);
                _shareLog(entry);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('删除日志', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _deleteLog(entry);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'multi_select':
        setState(() {
          _isMultiSelectMode = true;
          _selectedLogIds.clear();
        });
        break;
      case 'delete_all':
        _showDeleteAllDialog();
        break;
    }
  }

  Future<void> _copyLogContent(LogEntry entry) async {
    final service = ref.read(fileLoggerServiceProvider);
    final content = await service.exportLog(entry);
    await Clipboard.setData(ClipboardData(text: content));
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('日志内容已复制到剪贴板')));
    }
  }

  Future<void> _shareLog(LogEntry entry) async {
    final service = ref.read(fileLoggerServiceProvider);
    final content = await service.exportLog(entry);

    if (entry.filePath != null && File(entry.filePath!).existsSync()) {
      await Share.shareXFiles([
        XFile(entry.filePath!),
      ], subject: '日志文件 - ${entry.level.label}');
    } else {
      await Share.share(content, subject: '日志内容 - ${entry.level.label}');
    }
  }

  Future<void> _exportAllLogs() async {
    try {
      final entries = ref.read(logEntriesProvider).value ?? [];
      if (entries.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('没有日志可导出')));
        return;
      }

      final service = ref.read(fileLoggerServiceProvider);
      final buffer = StringBuffer();

      for (final entry in entries) {
        buffer.writeln(await service.exportLog(entry));
        buffer.writeln('\n');
      }

      await Share.share(buffer.toString(), subject: '全部日志');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('导出失败: $e')));
      }
    }
  }

  Future<void> _deleteLog(LogEntry entry) async {
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

    if (confirmed == true) {
      await ref.read(logEntriesProvider.notifier).deleteLog(entry);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('日志已删除')));
      }
    }
  }

  Future<void> _deleteSelected() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除选中日志'),
        content: Text('确定要删除选中的${_selectedLogIds.length}条日志吗？'),
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

    if (confirmed == true) {
      final entries = ref.read(logEntriesProvider).value ?? [];
      final selectedEntries = entries
          .where((e) => _selectedLogIds.contains(e.id))
          .toList();

      await ref.read(logEntriesProvider.notifier).deleteLogs(selectedEntries);

      setState(() {
        _isMultiSelectMode = false;
        _selectedLogIds.clear();
      });

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('选中日志已删除')));
      }
    }
  }

  Future<void> _showDeleteAllDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('清除全部日志'),
        content: const Text('确定要清除所有日志吗？此操作不可恢复。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('清除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(logEntriesProvider.notifier).deleteAllLogs();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('所有日志已清除')));
      }
    }
  }

  Future<void> _showCleanupDialog(CleanupRecommendation recommendation) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('清理日志'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(recommendation.reason),
            const SizedBox(height: 16),
            Text('将清理${recommendation.oldEntriesCount}条过期日志。'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('清理'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final count = await ref
          .read(cleanupRecommendationProvider.notifier)
          .cleanupOldLogs();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('已清理$count条过期日志')));
      }
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
    return '${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
