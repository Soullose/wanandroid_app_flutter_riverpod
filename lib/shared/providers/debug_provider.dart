import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'debug_provider.g.dart';

/// 调试用设备信息浮动面板的可见性状态
@riverpod
class DebugPanelVisible extends _$DebugPanelVisible {
  @override
  bool build() => false;

  void toggle() => state = !state;
  void show() => state = true;
  void hide() => state = false;
}
