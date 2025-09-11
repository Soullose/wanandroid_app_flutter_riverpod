import 'package:wanandroid_app_flutter_riverpod/features/article/domain/entities/article_list.dart';

import '../../domain/repositories/article_repository.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  ArticleRepositoryImpl();

  @override
  Future<List<Articles>> getArticles(int page) {
    // TODO: implement getArticles
    throw UnimplementedError();
  }

  @override
  Future<List<Articles>> getDefaultArticles() {
    // TODO: implement getDefaultArticles
    throw UnimplementedError();
  }

  @override
  Future<List<Articles>> getTopArticles() {
    // TODO: implement getTopArticles
    throw UnimplementedError();
  }
}
