import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wanandroid_app_flutter_riverpod/features/article/domain/entities/article_state.dart';

import '../../infrastructure/repositories/article_repository_impl.dart';

part 'articles_provider.g.dart';

@riverpod
class Articles extends _$Articles {
  @override
  FutureOr<ArticleState> build() async {
    return await _fetchArticles(0);
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
    // 如果已经在加载或者已经到底了，则不执行任何操作
    if (state.isLoading || state.value!.hasReachedMax) {
      return;
    }

    final currentState = state.value!;
    final nextPage = currentState.page + 1;

    try {
      final newArticles =
          await ArticleRepositoryImpl(ref).getArticles(nextPage);
      if (newArticles.isEmpty) {
        state = AsyncValue.data(currentState.copyWith(hasReachedMax: true));
      } else {
        state = AsyncValue.data(
          currentState.copyWith(
            articles: [...currentState.articles, ...newArticles],
            page: nextPage,
          ),
        );
      }
    } catch (e, s) {
      // 在加载更多失败时，可以考虑如何处理错误状态
      // 这里我们简单地保持原有状态
      if (kDebugMode) {
        print('Failed to load more articles: $e $s');
      }
    }
  }
}
