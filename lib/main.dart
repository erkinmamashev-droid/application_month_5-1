import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:news_app/data/remote/api/news_data_source.dart';
import 'package:news_app/data/remote/impl/news_data_source_impl.dart';
import 'package:news_app/data/repo_impl/news_repository_impl.dart';
import 'package:news_app/domain/repo/news_repository.dart';
import 'package:news_app/ui/presentation/home_page.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

void main() {
  final dio = Dio(
    BaseOptions(
      baseUrl: "https://newsapi.org/v2/",
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  final talker = TalkerFlutter.init();

  dio.interceptors.add(
    TalkerDioLogger(
      talker: talker,
      settings: const TalkerDioLoggerSettings(
        printRequestData: true,
        printRequestHeaders: false,
        printResponseData: true,
        printResponseMessage: true,
        printResponseHeaders: true,
        printResponseTime: true,
        hiddenHeaders: {'X-Api-Key'},
      ),
    ),
  );

  final NewsDataSource dataSource = NewsDataSourceImpl(dio: dio);

  final NewsRepository newsRepository = NewsRepositoryImpl(
    dataSource: dataSource,
  );
  runApp(MyApp(repository: newsRepository));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.repository});

  final NewsRepository repository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage(newsRepository: repository));
  }
}
