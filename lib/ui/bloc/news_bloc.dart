import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/domain/repo/news_repository.dart';
import 'package:news_app/ui/bloc/news_event.dart';
import 'package:news_app/ui/bloc/news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  NewsBloc({required this.newsRepository}) : super(NewsInitial()) {
    on<GetEverythingEvent>(_getEverythingArticles);
    on<LoadMoreNewsEvent>(_loadMoreArticles);
  }

  final NewsRepository newsRepository;
  static const int _pageSize = 20;
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  FutureOr<void> _getEverythingArticles(
    GetEverythingEvent event,
    Emitter<NewsState> emit,
  ) async {
    _currentPage = 1;
    _hasMore = true;
    emit(NewsLoading());
    try {
      final result = await newsRepository.getEverythingArticles(
        page: _currentPage,
      );
      _hasMore = result.length == _pageSize;
      emit(NewsSuccess(news: result, hasMore: _hasMore));
    } catch (_) {
      emit(NewsFailure("Новостей нет"));
    }
  }

  FutureOr<void> _loadMoreArticles(
    LoadMoreNewsEvent event,
    Emitter<NewsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! NewsSuccess || !_hasMore || _isLoadingMore) return;

    _isLoadingMore = true;
    emit(
      NewsSuccess(
        news: currentState.news,
        hasMore: _hasMore,
        isLoadingMore: true,
      ),
    );

    final nextPage = _currentPage + 1;
    try {
      final result = await newsRepository.getEverythingArticles(page: nextPage);
      _currentPage = nextPage;
      _hasMore = result.length == _pageSize;
      emit(
        NewsSuccess(news: [...currentState.news, ...result], hasMore: _hasMore),
      );
    } catch (_) {
      emit(
        NewsSuccess(
          news: currentState.news,
          hasMore: _hasMore,
          loadMoreError: 'Не удалось загрузить новости. Попробуйте ещё раз.',
        ),
      );
    } finally {
      _isLoadingMore = false;
    }
  }
}
