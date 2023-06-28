// To parse this JSON data, do
//
//     final banner = bannerFromJson(jsonString);
///首页banner
import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'banner.freezed.dart';
part 'banner.g.dart';



List<Banner> bannerFromJson(String str) =>
    List<Banner>.from(json.decode(str).map((x) => Banner.fromJson(x)));

String bannerToJson(List<Banner> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@freezed
class Banner with _$Banner {
  const factory Banner({
    String? desc,
    int? id,
    String? imagePath,
    int? isVisible,
    int? order,
    String? title,
    int? type,
    String? url,
  }) = _Banner;

  factory Banner.fromJson(Map<String, dynamic> json) => _$BannerFromJson(json);
}
