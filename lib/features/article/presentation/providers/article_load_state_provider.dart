import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wanandroid_app_flutter_riverpod/features/article/domain/entities/article_load_status.dart';

part 'article_load_state_provider.g.dart';

@riverpod
class ArticleLoadStateNotifier extends _$ArticleLoadStateNotifier {
  @override
  ArticleLoadStatus build() {
    return const ArticleLoadStatus();
  }

  void setLoading() {
    state = state.copyWith(isLoadingMore: true, loadMoreError: null);
  }

  void setLoaded() {
    state = state.copyWith(isLoadingMore: false);
  }

  void setReachedMax() {
    state = state.copyWith(isLoadingMore: false, hasReachedMax: true);
  }

  void setError(String error) {
    state = state.copyWith(isLoadingMore: false, loadMoreError: error);
  }

  void clearError() {
    state = state.copyWith(loadMoreError: null);
  }
}
