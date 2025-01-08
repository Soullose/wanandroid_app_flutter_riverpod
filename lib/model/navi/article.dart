import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'article.freezed.dart';

part 'article.g.dart';

Article articleFromJson(String str) => Article.fromJson(json.decode(str));

String articleToJson(Article data) => json.encode(data.toJson());

@freezed
class Article with _$Article {
  const factory Article({
    required bool adminAdd,
    required String apkLink,
    required int audit,
    required String author,
    required bool canEdit,
    required int chapterId,
    required String chapterName,
    required bool collect,
    required int courseId,
    required String desc,
    required String descMd,
    required String envelopePic,
    required bool fresh,
    required String host,
    required int id,
    required bool isAdminAdd,
    required String link,
    required String niceDate,
    required String niceShareDate,
    required String origin,
    required String prefix,
    required String projectLink,
    required int publishTime,
    required int realSuperChapterId,
    required int selfVisible,
    required dynamic shareDate,
    required String shareUser,
    required int superChapterId,
    required String superChapterName,
    required List<dynamic> tags,
    required String title,
    required int type,
    required int userId,
    required int visible,
    required int zan,
  }) = _Article;

  factory Article.fromJson(Map<String, dynamic> json) =>
      _$ArticleFromJson(json);
}
