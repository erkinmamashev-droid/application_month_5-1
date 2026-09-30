import 'package:news_app/data/remote/api/news_data_source.dart';
import 'package:news_app/domain/entity/news_article_entity.dart';
import 'package:news_app/domain/repo/news_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  const NewsRepositoryImpl({required this.dataSource});

  final NewsDataSource dataSource;

  @override
  Future<List<NewsArticleEntity>> getEverythingArticles({
    required int page,
  }) async {
    final result = await dataSource.getEverythingArticles(page: page);
    return result.map((model) => model.fromModelToEntity()).toList();
  }
}
