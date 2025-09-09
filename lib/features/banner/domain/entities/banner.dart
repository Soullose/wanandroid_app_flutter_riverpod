// To parse this JSON data, do
//
//     final banner = bannerFromJson(jsonString);

import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'banner.freezed.dart';
part 'banner.g.dart';

List<Banner> bannerFromJson(String str) {
  final decoded = jsonDecode(str) as List;
  return List<Banner>.from(
      decoded.map((x) => Banner.fromJson(x as Map<String, dynamic>)));
}

String bannerToJson(List<Banner> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@freezed
abstract class Banner with _$Banner {
  const factory Banner({
    required String desc,
    required int id,
    required String imagePath,
    required int isVisible,
    required int order,
    required String title,
    required int type,
    required String url,
  }) = _Banner;

  factory Banner.fromJson(Map<String, dynamic> json) => _$BannerFromJson(json);
}
