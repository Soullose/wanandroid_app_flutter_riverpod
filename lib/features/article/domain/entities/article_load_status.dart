import 'package:freezed_annotation/freezed_annotation.dart';

part 'article_load_status.freezed.dart';

part 'article_load_status.g.dart';

@freezed
abstract class ArticleLoadStatus with _$ArticleLoadStatus {
  const factory ArticleLoadStatus({
    @Default(false) bool isLoadingMore,
    @Default(false) bool hasReachedMax,
    String? loadMoreError,
  }) = _ArticleLoadStatus;

  factory ArticleLoadStatus.fromJson(Map<String, dynamic> json) =>
      _$ArticleLoadStatusFromJson(json);
}
