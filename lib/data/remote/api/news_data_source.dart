import 'package:news_app/data/model/news_article_model.dart';

abstract class NewsDataSource {
  Future<List<NewsArticleModel>> getEverythingArticles({required int page});
}
