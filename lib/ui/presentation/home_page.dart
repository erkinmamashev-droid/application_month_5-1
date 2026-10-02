import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/domain/entity/news_article_entity.dart';
import 'package:news_app/ui/bloc/news_bloc.dart';
import 'package:news_app/ui/bloc/news_event.dart';
import 'package:news_app/ui/bloc/news_state.dart';
import 'package:news_app/ui/presentation/news_details_page.dart';
import 'package:news_app/ui/presentation/widgets/article_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.createNewsBloc});

  final NewsBloc Function() createNewsBloc;

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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 18),
                    child: Text(
                      'Новости',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
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
                  GetEverythingEvent(query: _query.trim()),
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
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 18,
                mainAxisSpacing: 24,
                mainAxisExtent: 366,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final article = articles[index];
                return ArticleTile(
                  article: article,
                  onTap: () => _openDetails(context, article),
                );
              }, childCount: articles.length),
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

  void _openDetails(BuildContext context, NewsArticleEntity article) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => NewsDetailsPage(article: article),
      ),
    );
  }

  void _search(BuildContext context) {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;
    context.read<NewsBloc>().add(GetEverythingEvent(query: query));
  }
}
