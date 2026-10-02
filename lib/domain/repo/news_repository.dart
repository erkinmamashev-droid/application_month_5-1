import 'package:news_app/domain/entity/news_article_entity.dart';

abstract class NewsRepository {
  Future<List<NewsArticleEntity>> getEverythingArticles({
    required int page,
    required String query,
  });
}
