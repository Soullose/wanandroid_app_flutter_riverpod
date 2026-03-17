import 'package:freezed_annotation/freezed_annotation.dart';

import 'article_list.dart';

part 'article_state.freezed.dart';

part 'article_state.g.dart';

@freezed
abstract class ArticleState with _$ArticleState {
  const factory ArticleState({
    required List<Articles> articles,
    required int page,
    required bool hasReachedMax,
    @Default(false) bool isLoadingMore,
    @Default(null) String? loadMoreError,
  }) = _ArticleState;

  factory ArticleState.fromJson(Map<String, dynamic> json) =>
      _$ArticleStateFromJson(json);
}
