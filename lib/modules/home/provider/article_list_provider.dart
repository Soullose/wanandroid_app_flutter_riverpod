import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wanandroid_app_flutter_riverpod/common/constants/api_address.dart';
import 'package:wanandroid_app_flutter_riverpod/common/net/http_client.dart';
import 'package:wanandroid_app_flutter_riverpod/common/net/result_data.dart';
import 'package:wanandroid_app_flutter_riverpod/model/models.dart';

part 'article_list_provider.g.dart';

@riverpod
class ArticleList extends _$ArticleList {
  // final http;

  int currentPage = 0;
  int pageCount = 0;

  Future<List<Articles>?> _fetchArticles() async {
    final httpManager = ref.read(httpManagerProvider.notifier);
    ResultData? response =
        await httpManager.netFetch(ApiAddress.articleUrl(pageNumber: 0));
    late PaginationData<Articles> articles = PaginationData<Articles>.fromJson(
        response?.getData(), (json) => Articles.fromJson(json));
    if (kDebugMode) {
      print('articles:${articles.datas}');
    }
    currentPage = articles.curPage!;
    pageCount = articles.pageCount! - 1;
    return articles.datas;
  }

  @override
  FutureOr<List<Articles>?> build() {
    // final http = ref.read(httpManagerProvider.notifier);
    return _fetchArticles();
  }

  Future<void> fetchNewArticles() async {
    if (pageCount == currentPage) {
      return;
    }
    if (kDebugMode) {
      print('当前页:$currentPage');
    }
    final httpManager = ref.read(httpManagerProvider.notifier);
    ResultData? response = await httpManager
        .netFetch(ApiAddress.articleUrl(pageNumber: currentPage++));
    late PaginationData<Articles> articles = PaginationData<Articles>.fromJson(
        response?.getData(), (json) => Articles.fromJson(json));
    currentPage = articles.curPage!;
    // state = AsyncData(articles.datas);
    // state.copyWithPrevious(AsyncValue<List<Articles>?>.data(articles.datas));
    state = AsyncValue.data([...(state.value ?? []), ...?articles.datas]);
    // return articlesFromJson(jsonEncode(response?.getData()['datas']));
  }
}

@riverpod
class ShowFab extends _$ShowFab {
  @override
  bool build() {
    return false;
  }

  void enableFab() {
    state = true;
  }

  void disableFab() {
    state = false;
  }
}
