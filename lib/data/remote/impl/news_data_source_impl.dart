import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:news_app/data/model/news_article_model.dart';
import 'package:news_app/data/remote/api/news_data_source.dart';

abstract final class _ApiPath {
  static const String everyThing = "everything";
  static const String apiKey = "9941da606ad2474c8a3c60939772cada";
  static const int pageSize = 20;
}

@LazySingleton(as: NewsDataSource)
class NewsDataSourceImpl implements NewsDataSource {
  const NewsDataSourceImpl({required this.dio});

  final Dio dio;

  @override
  Future<List<NewsArticleModel>> getEverythingArticles({
    required int page,
    required String query,
  }) async {
    final fromDate = DateTime.now().subtract(const Duration(days: 29));
    final formattedFromDate =
        '${fromDate.year}-${fromDate.month.toString().padLeft(2, '0')}-${fromDate.day.toString().padLeft(2, '0')}';
    final response = await dio.get(
      _ApiPath.everyThing,
      queryParameters: {
        'q': query,
        'from': formattedFromDate,
        'sortBy': 'publishedAt',
        'page': page,
        'pageSize': _ApiPath.pageSize,
        'apiKey': _ApiPath.apiKey,
      },
    );
    return NewsArticleModel.fromJsonList(response.data["articles"]);
  }
}
