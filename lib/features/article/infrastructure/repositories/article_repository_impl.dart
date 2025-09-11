import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wanandroid_app_flutter_riverpod/features/article/domain/entities/article_list.dart';

import '../../../../core/net/http_client.dart';
import '../../domain/repositories/article_repository.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  final Ref _ref;

  ArticleRepositoryImpl(this._ref);

  @override
  Future<List<Articles>> getArticles(int page) {
    final httpManager = _ref.read(httpManagerProvider.notifier);
    // TODO: implement getArticles
    throw UnimplementedError();
  }

  @override
  Future<List<Articles>> getDefaultArticles() {
    final httpManager = _ref.read(httpManagerProvider.notifier);
    // TODO: implement getDefaultArticles
    throw UnimplementedError();
  }

  @override
  Future<List<Articles>> getTopArticles() {
    final httpManager = _ref.read(httpManagerProvider.notifier);
    // TODO: implement getTopArticles
    throw UnimplementedError();
  }
}
