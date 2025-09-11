import '../entities/article_list.dart';

abstract class ArticleRepository {
  /// 获取置顶文章
  Future<List<Articles>> getTopArticles();

  /// 获取首页文章
  Future<List<Articles>> getDefaultArticles();

  /// 获取文章根据页数
  Future<List<Articles>> getArticles(int page);
}
