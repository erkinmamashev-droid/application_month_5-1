import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:news_app/data/model/news_article_model.dart';
import 'package:news_app/data/remote/api/news_data_source.dart';

abstract final class _ApiPath {
  static const String everything = 'everything';
  static const String fromDate = '2026-10-01';
  static const String toDate = '2026-10-05';
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
    String sortBy = 'publishedAt',
  }) async {
    final response = await dio.get(
      _ApiPath.everything,
      queryParameters: {
        'q': query,
        'from': _ApiPath.fromDate,
        'to': _ApiPath.toDate,
        'sortBy': sortBy,
        'page': page,
        'pageSize': _ApiPath.pageSize,
        'apiKey': _ApiPath.apiKey,
      },
    );
    return NewsArticleModel.fromJsonList(response.data["articles"]);
  }
}
