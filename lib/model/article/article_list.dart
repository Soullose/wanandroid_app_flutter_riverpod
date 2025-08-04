// To parse this JSON data, do
//
//     final articles = articlesFromJson(jsonString);

// import 'package:freezed_annotation/freezed_annotation.dart';
// import 'dart:convert';

// part 'article_list.freezed.dart';
// part 'article_list.g.dart';
import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'article_list.freezed.dart';
part 'article_list.g.dart';

List<Articles> articlesFromJson(String str) =>
    List<Articles>.from((json.decode(str) as List)
        .map((x) => Articles.fromJson(x as Map<String, dynamic>)));

String articlesToJson(List<Articles> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@freezed
abstract class Articles with _$Articles {
  const factory Articles({
    bool? adminAdd,
    String? apkLink,
    int? audit,
    String? author,
    bool? canEdit,
    int? chapterId,
    String? chapterName,
    bool? collect,
    int? courseId,
    String? desc,
    String? descMd,
    String? envelopePic,
    bool? fresh,
    String? host,
    int? id,
    bool? isAdminAdd,
    String? link,
    String? niceDate,
    String? niceShareDate,
    String? origin,
    String? prefix,
    String? projectLink,
    int? publishTime,
    int? realSuperChapterId,
    int? selfVisible,
    int? shareDate,
    String? shareUser,
    int? superChapterId,
    String? superChapterName,
    List<Tag>? tags,
    String? title,
    int? type,
    int? userId,
    int? visible,
    int? zan,
  }) = _Articles;

  factory Articles.fromJson(Map<String, dynamic> json) =>
      _$ArticlesFromJson(json);
}

@freezed
abstract class Tag with _$Tag {
  const factory Tag({
    String? name,
    String? url,
  }) = _Tag;

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);
}

// enum Author { EMPTY, AUTHOR, PURPLE, FLUFFY }
//
// final authorValues = EnumValues({
//   "鸿洋": Author.AUTHOR,
//   "": Author.EMPTY,
//   "郭霖": Author.FLUFFY,
//   "张鸿洋": Author.PURPLE
// });

//
// class EnumValues<T> {
//   Map<String, T> map;
//   late Map<T, String> reverseMap;
//
//   EnumValues(this.map);
//
//   Map<T, String> get reverse {
//     reverseMap = map.map((k, v) => MapEntry(v, k));
//     return reverseMap;
//   }
// }
