import 'package:injectable/injectable.dart';
import 'package:news_app/data/remote/api/news_data_source.dart';
import 'package:news_app/domain/entity/news_article_entity.dart';
import 'package:news_app/domain/repo/news_repository.dart';

@LazySingleton(as: NewsRepository)
class NewsRepositoryImpl implements NewsRepository {
  const NewsRepositoryImpl({required this.dataSource});

  final NewsDataSource dataSource;

  @override
  Future<List<NewsArticleEntity>> getEverythingArticles({
    required int page,
    required String query,
    String sortBy = 'publishedAt',
  }) async {
    final result = await dataSource.getEverythingArticles(
      page: page,
      query: query,
      sortBy: sortBy,
    );
    return result.map((model) => model.fromModelToEntity()).toList();
  }
}
