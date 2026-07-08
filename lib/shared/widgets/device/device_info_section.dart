import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wanandroid_app_flutter_riverpod/src/rust/api/device_info.dart' as rust;

/// 可直接嵌入设置页面的设备信息模块
///
/// 展示从 Rust 侧采集的 CPU/内存/磁盘/网络等深度信息，
/// 每 5 秒自动刷新一次。
class DeviceInfoSection extends ConsumerStatefulWidget {
  const DeviceInfoSection({super.key});

  @override
  ConsumerState<DeviceInfoSection> createState() => _DeviceInfoSectionState();
}

class _DeviceInfoSectionState extends ConsumerState<DeviceInfoSection> {
  rust.DeepDeviceInfo? _deepInfo;
  bool _isLoading = false;
  String? _error;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _refreshTimer = Timer.periodic(const Duration(seconds: 5), (_) => _fetchData());
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchData() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    try {
      final info = await rust.collectDeepDeviceInfo();
      if (mounted) {
        setState(() {
          _deepInfo = info;
          _error = null;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(colorScheme),
            const Divider(height: 12),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text('❌ $_error',
                    style: const TextStyle(fontSize: 12, color: Colors.red)),
              )
            else if (_deepInfo == null)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(),
                ),
              )
            else
              _buildInfoContent(colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ColorScheme colorScheme) {
    return Row(
      children: [
        Text('📊 设备信息',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: colorScheme.onSurface)),
        const Spacer(),
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.only(right: 8),
            child: SizedBox(
                width: 12, height: 12,
                child: CircularProgressIndicator(strokeWidth: 2)),
          ),
        IconButton(
          icon: Icon(Icons.refresh, size: 18, color: colorScheme.primary),
          onPressed: _fetchData,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }

  Widget _buildInfoContent(ColorScheme colorScheme) {
    final info = _deepInfo!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('💻 系统', colorScheme),
        _buildKeyValue('主机名', info.system.hostName),
        _buildKeyValue('系统',
            '${info.system.osName} ${info.system.osVersion}'),
        _buildKeyValue('内核', info.system.kernelVersion),
        _buildKeyValue('运行时长',
            _formatDuration(info.system.uptimeSeconds)),
        _buildKeyValue('负载',
            '${info.system.loadAverageOne.toStringAsFixed(2)} / ${info.system.loadAverageFive.toStringAsFixed(2)} / ${info.system.loadAverageFifteen.toStringAsFixed(2)}'),

        const SizedBox(height: 8),
        _buildSectionTitle('🧠 CPU', colorScheme),
        _buildKeyValue('型号', _crop(info.cpu.brand, 40)),
        _buildKeyValue('架构', info.cpu.arch),
        _buildKeyValue('核心',
            '${info.cpu.physicalCoreCount ?? "?"} 物理 / ${info.cpu.logicalCoreCount} 逻辑'),
        _buildKeyValue(
            '主频', '${info.cpu.globalFrequencyMhz} MHz'),
        _buildProgressBar(
            '使用率', info.cpu.globalUsagePercent, Colors.blue),

        const SizedBox(height: 8),
        _buildSectionTitle('🧮 内存', colorScheme),
        _buildKeyValue('总量', _bytesHuman(info.memory.totalBytes)),
        _buildKeyValue('已用 / 可用',
            '${_bytesHuman(info.memory.usedBytes)} / ${_bytesHuman(info.memory.availableBytes)}'),
        _buildProgressBar(
            '使用率', info.memory.usagePercent, Colors.purple),
        if (info.memory.swapTotalBytes > BigInt.zero)
          _buildKeyValue('Swap',
              '${_bytesHuman(info.memory.swapUsedBytes)} / ${_bytesHuman(info.memory.swapTotalBytes)}'),

        if (info.disks.isNotEmpty) ...[
          const SizedBox(height: 8),
          _buildSectionTitle('💾 磁盘', colorScheme),
          ...info.disks.take(3).map(_buildDiskItem),
          if (info.disks.length > 3)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text('… 还有 ${info.disks.length - 3} 个',
                  style: TextStyle(
                      fontSize: 10,
                      color: colorScheme.onSurfaceVariant)),
            ),
        ],

        if (info.networkInterfaces.isNotEmpty) ...[
          const SizedBox(height: 8),
          _buildSectionTitle('🌐 网络', colorScheme),
          ...info.networkInterfaces
              .take(3)
              .map((n) => _buildNetworkItem(n, colorScheme)),
        ],
      ],
    );
  }

  Widget _buildSectionTitle(String text, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(text,
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colorScheme.primary)),
    );
  }

  Widget _buildKeyValue(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        children: [
          SizedBox(
              width: 80,
              child: Text(label,
                  style: const TextStyle(
                      fontSize: 11, color: Colors.grey))),
          Expanded(
            child: Text(value,
                style: const TextStyle(fontSize: 11),
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(
      String label, double percent, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          const SizedBox(
              width: 80,
              child: Text('',
                  style: TextStyle(fontSize: 11))),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percent / 100,
                backgroundColor: color.withOpacity(0.15),
                valueColor: AlwaysStoppedAnimation(color),
                minHeight: 8,
              ),
            ),
          ),
          const SizedBox(width: 6),
          SizedBox(
            width: 44,
            child: Text('${percent.toStringAsFixed(1)}%',
                style: const TextStyle(fontSize: 10),
                textAlign: TextAlign.right),
          ),
        ],
      ),
    );
  }

  Widget _buildDiskItem(rust.DiskInfo disk) {
    final usedPercent = disk.totalBytes > BigInt.zero
        ? (disk.totalBytes - disk.availableBytes).toInt() /
                disk.totalBytes.toInt() *
            100
        : 0.0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${disk.mountPoint} (${disk.diskType})',
              style: const TextStyle(fontSize: 10)),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: usedPercent / 100,
                    backgroundColor: Colors.teal.withOpacity(0.15),
                    valueColor: AlwaysStoppedAnimation(
                        usedPercent > 85 ? Colors.red : Colors.teal),
                    minHeight: 6,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Text('${usedPercent.toStringAsFixed(0)}%',
                  style: const TextStyle(fontSize: 10)),
            ],
          ),
          Text(
              '${_bytesHuman(disk.availableBytes)} 可用 / ${_bytesHuman(disk.totalBytes)}',
              style:
                  const TextStyle(fontSize: 9, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildNetworkItem(
      rust.NetworkInterfaceInfo net, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(net.name,
                  style: const TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w500)),
              const SizedBox(width: 8),
              Text(net.macAddress,
                  style: TextStyle(
                      fontSize: 9,
                      color: colorScheme.onSurfaceVariant)),
            ],
          ),
          if (net.ipAddresses.isNotEmpty)
            Text(net.ipAddresses.join(', '),
                style:
                    const TextStyle(fontSize: 9, color: Colors.grey)),
          Text(
            '📥 ${_bytesHuman(net.totalReceivedBytes)} / 📤 ${_bytesHuman(net.totalTransmittedBytes)}',
            style:
                const TextStyle(fontSize: 9, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // ── 工具方法 ──

  String _bytesHuman(BigInt bytes) {
    if (bytes <= BigInt.zero) return '0 B';
    const units = ['B', 'KB', 'MB', 'GB', 'TB'];
    var size = bytes.toInt().toDouble();
    var i = 0;
    while (size >= 1024 && i < units.length - 1) {
      size /= 1024;
      i++;
    }
    return '${size.toStringAsFixed(1)} ${units[i]}';
  }

  String _formatDuration(BigInt seconds) {
    final d = Duration(seconds: seconds.toInt());
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    if (h > 24) {
      return '${h ~/ 24}d ${h % 24}h';
    } else if (h > 0) {
      return '${h}h ${m}m';
    } else if (m > 0) {
      return '${m}m ${s}s';
    }
    return '${s}s';
  }

  String _crop(String s, int max) =>
      s.length <= max ? s : '${s.substring(0, max)}…';
}
