// To parse this JSON data, do
//
//     final architecture = architectureFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'architecture.freezed.dart';

part 'architecture.g.dart';

// Architecture architectureFromJson(String str) =>
//     Architecture.fromJson(json.decode(str));
//
// String architectureToJson(Architecture data) => json.encode(data.toJson());

/// 体系数据
@freezed
abstract class Architecture with _$Architecture {
  const factory Architecture({
    required List<dynamic> articleList,
    required String author,
    required List<Architecture> children,
    required int courseId,
    required String cover,
    required String desc,
    required int id,
    required String lisense,
    required String lisenseLink,
    required String name,
    required int order,
    required int parentChapterId,
    required int type,
    required bool userControlSetTop,
    required int visible,
  }) = _Architecture;

  factory Architecture.fromJson(Map<String, dynamic> json) =>
      _$ArchitectureFromJson(json);
}
