import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wanandroid_app_flutter_riverpod/model/navi/article.dart';

part 'navi.freezed.dart';

part 'navi.g.dart';

@freezed
abstract class Navi with _$Navi {
  const factory Navi({
    required List<Article> articles,
    required int cid,
    required String name,
  }) = _Navi;

  factory Navi.fromJson(Map<String, dynamic> json) => _$NaviFromJson(json);
}
