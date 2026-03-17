import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wanandroid_app_flutter_riverpod/features/article/domain/entities/article_state.dart';

import '../../infrastructure/repositories/article_repository_impl.dart';

part 'articles_provider.g.dart';

@riverpod
class Articles extends _$Articles {
  @override
  FutureOr<ArticleState> build() {
    return _fetchArticles(0);
  }

  Future<ArticleState> _fetchArticles(int page) async {
    final newArticles = await ArticleRepositoryImpl(ref).getDefaultArticles();
    return ArticleState(
      articles: newArticles,
      page: page,
      hasReachedMax: newArticles.isEmpty,
    );
  }

  Future<void> refresh() async {
    // 将状态设置为加载中，并重新获取第一页数据
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchArticles(0));
  }

  Future<void> loadMore() async {
    final currentState = state.value;

    // 如果没有数据、已经在加载更多、或者已经到底了，则不执行任何操作
    if (currentState == null ||
        currentState.isLoadingMore ||
        currentState.hasReachedMax) {
      return;
    }

    // 设置加载更多状态
    state = AsyncValue.data(
      currentState.copyWith(isLoadingMore: true, loadMoreError: null),
    );

    final nextPage = currentState.page + 1;

    try {
      final newArticles = await ArticleRepositoryImpl(
        ref,
      ).getArticles(nextPage);
      if (newArticles.isEmpty) {
        state = AsyncValue.data(
          currentState.copyWith(hasReachedMax: true, isLoadingMore: false),
        );
      } else {
        state = AsyncValue.data(
          currentState.copyWith(
            articles: [...currentState.articles, ...newArticles],
            page: nextPage,
            isLoadingMore: false,
          ),
        );
      }
    } catch (e, s) {
      // 在加载更多失败时，设置错误状态
      if (kDebugMode) {
        debugPrint('Failed to load more articles: $e');
        debugPrint('Stack trace: $s');
      }
      state = AsyncValue.data(
        currentState.copyWith(
          isLoadingMore: false,
          loadMoreError: e.toString(),
        ),
      );
    }
  }

  /// 清除加载更多错误状态
  void clearLoadMoreError() {
    final currentState = state.value;
    if (currentState != null && currentState.loadMoreError != null) {
      state = AsyncValue.data(currentState.copyWith(loadMoreError: null));
    }
  }
}
