

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wanandroid_app_flutter_riverpod/common/constants/api_address.dart';

import '../../../common/net/http_client.dart';
import '../../../model/article/article_list.dart';

part 'article_list_provider.g.dart';

@riverpod
class ArticleList extends _$ArticleList {
  // final http;

  Future<List<Articles>> _fetchArticles() async {
    final httpManager = ref.read(httpManagerProvider.notifier);
    dynamic response =
        await httpManager.netFetch(ApiAddress.articleUrl(pageNumber: 0));
    if(kDebugMode) {
      print(jsonEncode(response.data['data']['datas']));
    }
    return articlesFromJson(jsonEncode(response.data['data']));
  }

  @override
  FutureOr build() {
    // final http = ref.read(httpManagerProvider.notifier);
    return _fetchArticles();
  }
}
