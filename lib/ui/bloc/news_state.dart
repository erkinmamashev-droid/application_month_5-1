import 'package:equatable/equatable.dart';
import 'package:news_app/domain/entity/news_article_entity.dart';

sealed class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object?> get props => [];
}

class NewsInitial extends NewsState {
  const NewsInitial();
}

class NewsLoading extends NewsState {
  const NewsLoading();
}

class NewsSuccess extends NewsState {
  const NewsSuccess({
    required this.news,
    this.hotNews = const [],
    this.hasMore = true,
    this.isLoadingMore = false,
    this.loadMoreError,
  });

  final List<NewsArticleEntity> news;
  final List<NewsArticleEntity> hotNews;
  final bool hasMore;
  final bool isLoadingMore;
  final String? loadMoreError;

  @override
  List<Object?> get props => [
    news,
    hotNews,
    hasMore,
    isLoadingMore,
    loadMoreError,
  ];
}

class NewsFailure extends NewsState {
  const NewsFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
