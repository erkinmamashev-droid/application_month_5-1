import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/domain/entity/news_article_entity.dart';
import 'package:news_app/ui/bloc/news_bloc.dart';
import 'package:news_app/ui/bloc/news_event.dart';
import 'package:news_app/ui/bloc/news_state.dart';
import 'package:news_app/ui/presentation/widgets/article_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.createNewsBloc,
    required this.onArticleTap,
  });

  final NewsBloc Function() createNewsBloc;
  final ValueChanged<NewsArticleEntity> onArticleTap;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFA),
      body: SafeArea(
        child: BlocProvider(
          create: (_) =>
              widget.createNewsBloc()
                ..add(const GetEverythingEvent(query: 'football')),
          child: BlocBuilder<NewsBloc, NewsState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 18, 24, 22),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) => setState(() => _query = value),
                      onSubmitted: (_) => _search(context),
                      decoration: InputDecoration(
                        hintText: 'Поиск новостей',
                        prefixIcon: IconButton(
                          tooltip: 'Найти новости',
                          onPressed: () => _search(context),
                          icon: const Icon(Icons.search),
                        ),
                        suffixIcon: _query.isEmpty
                            ? null
                            : IconButton(
                                tooltip: 'Очистить поиск',
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() => _query = '');
                                  context.read<NewsBloc>().add(
                                    const GetEverythingEvent(query: 'football'),
                                  );
                                },
                                icon: const Icon(Icons.close),
                              ),
                        filled: true,
                        fillColor: const Color(0xFFF0F0ED),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                      ),
                    ),
                  ),
                  Expanded(child: _buildNewsContent(context, state)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildNewsContent(BuildContext context, NewsState state) {
    if (state is NewsLoading || state is NewsInitial) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF315C55)),
      );
    }
    if (state is NewsFailure) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(state.message, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: () => context.read<NewsBloc>().add(
                  GetEverythingEvent(query: _query.trim().isEmpty
                      ? 'football'
                      : _query.trim()),
                ),
                icon: const Icon(Icons.refresh),
                label: const Text('Загрузить ещё раз'),
              ),
            ],
          ),
        ),
      );
    }
    if (state is NewsSuccess) {
      final query = _query.trim();
      final articles = state.news;

      if (articles.isEmpty) {
        return Center(
          child: Text(
            query.isEmpty ? 'Новостей пока нет' : 'Ничего не найдено',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        );
      }

      return CustomScrollView(
        slivers: [
          if (state.hotNews.isNotEmpty)
            SliverToBoxAdapter(
              child: _NewsSection(
                title: 'Горячие новинки',
                articles: state.hotNews.take(5).toList(),
                onArticleTap: widget.onArticleTap,
              ),
            ),
          SliverToBoxAdapter(
            child: _NewsSection(
              title: query.isEmpty ? 'Главные новости' : 'Результаты поиска',
              articles: articles.take(5).toList(),
              onArticleTap: widget.onArticleTap,
            ),
          ),
          if (articles.length > 5)
            SliverToBoxAdapter(
              child: _NewsSection(
                title: query.isEmpty ? 'Ещё новости' : 'Другие результаты',
                articles: articles.skip(5).toList(),
                onArticleTap: widget.onArticleTap,
              ),
            ),
          if (state.hasMore)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                child: Column(
                  children: [
                    if (state.loadMoreError != null) ...[
                      Text(state.loadMoreError!, textAlign: TextAlign.center),
                      const SizedBox(height: 8),
                    ],
                    OutlinedButton.icon(
                      onPressed: state.isLoadingMore
                          ? null
                          : () => context.read<NewsBloc>().add(
                              const LoadMoreNewsEvent(),
                            ),
                      icon: state.isLoadingMore
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.expand_more),
                      label: Text(
                        state.isLoadingMore ? 'Загрузка...' : 'Загрузить ещё',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  void _search(BuildContext context) {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;
    context.read<NewsBloc>().add(GetEverythingEvent(query: query));
  }
}

class _NewsSection extends StatelessWidget {
  const _NewsSection({
    required this.title,
    required this.articles,
    required this.onArticleTap,
  });

  final String title;
  final List<NewsArticleEntity> articles;
  final ValueChanged<NewsArticleEntity> onArticleTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 14),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          SizedBox(
            height: 390,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              scrollDirection: Axis.horizontal,
              itemCount: articles.length,
              separatorBuilder: (_, _) => const SizedBox(width: 18),
              itemBuilder: (context, index) {
                final article = articles[index];
                return SizedBox(
                  width: 170,
                  child: ArticleTile(
                    article: article,
                    onTap: () => onArticleTap(article),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
