import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wanandroid_app_flutter_riverpod/common/constants/api_address.dart';
import 'package:wanandroid_app_flutter_riverpod/common/net/result_data.dart';

import '../../../common/net/http_client.dart';
import '../../../model/models.dart';

part 'article_list_provider.g.dart';

@riverpod
class ArticleList extends _$ArticleList {
  // final http;

  Future<List<Articles>> _fetchArticles() async {
    final httpManager = ref.read(httpManagerProvider.notifier);
    ResultData? response =
        await httpManager.netFetch(ApiAddress.articleUrl(pageNumber: 0));
    if (kDebugMode) {
      print(jsonEncode(response?.getData()['datas']));
    }
    late PaginationData<Articles> articles = PaginationData<Articles>.fromJson(
        response?.getData(), (json) => Articles.fromJson(json));
    if (kDebugMode) {
      print('articles:${articles}');
    }
    return articlesFromJson(jsonEncode(response?.getData()['datas']));
  }

  @override
  FutureOr build() {
    // final http = ref.read(httpManagerProvider.notifier);
    return _fetchArticles();
  }

  Future<void> fetchNewArticles(int pageNumber) async {
    final httpManager = ref.read(httpManagerProvider.notifier);
    ResultData? response = await httpManager
        .netFetch(ApiAddress.articleUrl(pageNumber: pageNumber));
    if (kDebugMode) {
      print(jsonEncode(response?.getData()['datas']));
    }
    final previousState = await future;
    late PaginationData<Articles> articles = PaginationData<Articles>.fromJson(
        response?.getData(), (json) => Articles.fromJson(json));
    state = AsyncData(articles.datas);
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
