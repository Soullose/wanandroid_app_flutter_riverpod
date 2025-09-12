import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wanandroid_app_flutter_riverpod/features/article/domain/entities/article_list.dart';

import '../../../../core/constants/api_address.dart';
import '../../../../core/net/http_client.dart';
import '../../../../core/net/result_data.dart';
import '../../../../model/pagination_data.dart';
import '../../domain/repositories/article_repository.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  final Ref _ref;

  ArticleRepositoryImpl(this._ref);

  @override
  Future<List<Articles>> getArticles(int page) async {
    final httpManager = _ref.read(httpManagerProvider.notifier);
    ResultData? response =
        await httpManager.netFetch(ApiAddress.articleUrl(pageNumber: page));
    late PaginationData<Articles> articles = PaginationData<Articles>.fromJson(
        response?.getData() as Map<String, dynamic>,
        (json) => Articles.fromJson(json as Map<String, dynamic>));
    if (kDebugMode) {
      print('articles:${articles.datas}');
    }
    // TODO: implement getArticles
    throw UnimplementedError();
  }

  @override
  Future<List<Articles>> getDefaultArticles() async {
    final httpManager = _ref.read(httpManagerProvider.notifier);
    ResultData? response =
        await httpManager.netFetch(ApiAddress.articleUrl(pageNumber: 0));
    late PaginationData<Articles> articles = PaginationData<Articles>.fromJson(
        response?.getData() as Map<String, dynamic>,
        (json) => Articles.fromJson(json as Map<String, dynamic>));
    if (kDebugMode) {
      print('articles:${articles.datas}');
    }
    return articles.datas ??  [];
  }

  @override
  Future<List<Articles>> getTopArticles() async {
    final httpManager = _ref.read(httpManagerProvider.notifier);
    ResultData? response = await httpManager.netFetch(ApiAddress.topArticleUrl);
    late PaginationData<Articles> articles = PaginationData<Articles>.fromJson(
        response?.getData() as Map<String, dynamic>,
        (json) => Articles.fromJson(json as Map<String, dynamic>));
    if (kDebugMode) {
      print('articles:${articles.datas}');
    }
    // TODO: implement getTopArticles
    throw UnimplementedError();
  }
}
