import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wanandroid_app_flutter_riverpod/core/constants/api_address.dart';
import 'package:wanandroid_app_flutter_riverpod/core/net/http_client.dart';
import 'package:wanandroid_app_flutter_riverpod/core/net/result_data.dart';
import 'package:wanandroid_app_flutter_riverpod/features/article/domain/entities/article_list.dart';
import 'package:wanandroid_app_flutter_riverpod/model/pagination_data.dart';

part 'article_list_provider.g.dart';

@riverpod
class ArticleList extends _$ArticleList {
  // final http;
  final GlobalKey<SliverAnimatedListState> _listKey =
      GlobalKey<SliverAnimatedListState>();
  int currentPage = 0;
  int pageCount = 0;

  late List currentList = [];
  late int oldLength = 0;

  Future<List<Articles>> _fetchArticles() async {
    final httpManager = ref.read(httpManagerProvider.notifier);
    ResultData? response =
        await httpManager.netFetch(ApiAddress.articleUrl(pageNumber: 0));
    late PaginationData<Articles> articles = PaginationData<Articles>.fromJson(
        response?.getData() as Map<String, dynamic>,
        (json) => Articles.fromJson(json as Map<String, dynamic>));
    if (kDebugMode) {
      print('articles:${articles.datas}');
    }
    currentPage = articles.curPage!;
    pageCount = articles.pageCount! - 1;

    currentList = articles.datas ?? [];
    oldLength = currentList.length;
    // 通知 SliverAnimatedList 插入新项目
    for (var i = 0; i < currentList.length; i++) {
      _listKey.currentState?.insertItem(
        oldLength + i,
        duration: const Duration(milliseconds: 300),
      );
    }
    return articles.datas ?? [];
  }

  @override
  FutureOr<List<Articles>> build() {
    // final http = ref.read(httpManagerProvider.notifier);
    listenSelf((prev, curr) {
      // prev?.value = [...(prev.value ?? []), ...?curr.value];
      print('xxx');
    });
    return _fetchArticles();
  }

  Future<void> fetchNewArticles() async {
    if (pageCount == currentPage) {
      return;
    }
    // state = const AsyncValue.loading();
    // state = const AsyncLoading<List<Articles>>().copyWithPrevious(state);
    if (kDebugMode) {
      print('当前页:$currentPage');
    }
    currentList = state.value ?? [];
    oldLength = currentList.length;

    final httpManager = ref.read(httpManagerProvider.notifier);
    ResultData? response = await httpManager
        .netFetch(ApiAddress.articleUrl(pageNumber: currentPage++));
    late PaginationData<Articles> articles = PaginationData<Articles>.fromJson(
        response?.getData() as Map<String, dynamic>,
        (json) => Articles.fromJson(json as Map<String, dynamic>));
    currentPage = articles.curPage!;
    state = AsyncValue.data([...(state.value ?? []), ...?articles.datas]);
    // 通知 SliverAnimatedList 插入新项目
    for (var i = 0; i < articles.datas!.length; i++) {
      _listKey.currentState?.insertItem(
        oldLength + i,
        duration: const Duration(milliseconds: 500),
      );
    }
  }

  GlobalKey<SliverAnimatedListState> get animatedListKey => _listKey;
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
