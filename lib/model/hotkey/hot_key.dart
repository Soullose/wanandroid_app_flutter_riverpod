import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'hot_key.freezed.dart';

part 'hot_key.g.dart';

Hotkey hotkeyFromJson(String str) => Hotkey.fromJson(json.decode(str));

String hotkeyToJson(Hotkey data) => json.encode(data.toJson());

@freezed
class Hotkey with _$Hotkey {
  const factory Hotkey({
    required int id,
    required String link,
    required String name,
    required int order,
    required int visible,
  }) = _Hotkey;

  factory Hotkey.fromJson(Map<String, dynamic> json) => _$HotkeyFromJson(json);
}
