import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wanandroid_app_flutter_riverpod/features/article/domain/entities/article_state.dart';
import 'package:wanandroid_app_flutter_riverpod/features/article/presentation/providers/article_load_state_provider.dart';

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
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    ref.read(articleLoadStateProvider.notifier).setLoaded();
    state = await AsyncValue.guard(() => _fetchArticles(0));
  }

  Future<void> loadMore() async {
    final currentState = state.value;

    final loadState = ref.read(articleLoadStateProvider.notifier);

    // 如果没有数据、已经在加载更多、或者已经到底了，则不执行任何操作
    if (currentState == null || state.isLoading) {
      return;
    }

    final currentLoadStatus = ref.read(articleLoadStateProvider);
    if (currentLoadStatus.isLoadingMore || currentLoadStatus.hasReachedMax) {
      return;
    }

    // 设置加载更多状态
    loadState.setLoading();

    final nextPage = currentState.page + 1;

    try {
      final newArticles = await ArticleRepositoryImpl(
        ref,
      ).getArticles(nextPage);
      if (newArticles.isEmpty) {
        loadState.setReachedMax();
      } else {
        state = AsyncValue.data(
          currentState.copyWith(
            articles: [...currentState.articles, ...newArticles],
            page: nextPage,
          ),
        );
        loadState.setLoaded();
      }
    } catch (e, s) {
      if (kDebugMode) {
        debugPrint('Failed to load more articles: $e');
        debugPrint('Stack trace: $s');
      }
      loadState.setError(e.toString());
    }
  }

  /// 清除加载更多错误状态
  void clearLoadMoreError() {
    ref.read(articleLoadStateProvider.notifier).clearError();
  }
}
