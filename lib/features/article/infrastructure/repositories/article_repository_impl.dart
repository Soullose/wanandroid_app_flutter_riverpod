import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wanandroid_app_flutter_riverpod/core/constants/api_address.dart';
import 'package:wanandroid_app_flutter_riverpod/core/net/http_client.dart';
import 'package:wanandroid_app_flutter_riverpod/core/net/result_data.dart';
import 'package:wanandroid_app_flutter_riverpod/core/net/result_data_extension.dart';
import 'package:wanandroid_app_flutter_riverpod/features/article/domain/entities/article_list.dart';
import 'package:wanandroid_app_flutter_riverpod/features/article/domain/repositories/article_repository.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  final Ref _ref;

  ArticleRepositoryImpl(this._ref);

  @override
  Future<List<Articles>> getArticles(int page) async {
    final httpManager = _ref.read(httpManagerProvider.notifier);
    ResultData? response = await httpManager.netFetch(
      ApiAddress.articleUrl(pageNumber: page),
    );

    // 使用扩展方法解析分页数据
    final paginationData = response?.parsePagination<Articles>(
      (json) => Articles.fromJson(json as Map<String, dynamic>),
    );

    if (paginationData == null) {
      if (kDebugMode) {
        print(
          'articles: response data is null, errorCode: ${response?.code}, errorMsg: ${response?.message}',
        );
      }
      return [];
    }

    if (kDebugMode) {
      print('articles:${paginationData.datas}');
    }
    return paginationData.datas ?? [];
  }

  @override
  Future<List<Articles>> getDefaultArticles() async {
    final httpManager = _ref.read(httpManagerProvider.notifier);
    ResultData? response = await httpManager.netFetch(
      ApiAddress.articleUrl(pageNumber: 0),
    );

    // 使用扩展方法解析分页数据
    final paginationData = response?.parsePagination<Articles>(
      (json) => Articles.fromJson(json as Map<String, dynamic>),
    );

    if (paginationData == null) {
      if (kDebugMode) {
        print(
          'articles: response data is null, errorCode: ${response?.code}, errorMsg: ${response?.message}',
        );
      }
      return [];
    }

    if (kDebugMode) {
      print('articles:${paginationData.datas?.length ?? 0}');
    }
    return paginationData.datas ?? [];
  }

  @override
  Future<List<Articles>> getTopArticles() async {
    final httpManager = _ref.read(httpManagerProvider.notifier);
    ResultData? response = await httpManager.netFetch(ApiAddress.topArticleUrl);

    // 使用扩展方法解析分页数据
    final paginationData = response?.parsePagination<Articles>(
      (json) => Articles.fromJson(json as Map<String, dynamic>),
    );

    if (paginationData == null) {
      if (kDebugMode) {
        print(
          'articles: response data is null, errorCode: ${response?.code}, errorMsg: ${response?.message}',
        );
      }
      return [];
    }

    if (kDebugMode) {
      print('articles:${paginationData.datas}');
    }
    return paginationData.datas ?? [];
  }
}
