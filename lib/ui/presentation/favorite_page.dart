import 'package:flutter/material.dart';
import 'package:news_app/domain/entity/news_article_entity.dart';
import 'package:news_app/ui/presentation/widgets/article_tile.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({
    super.key,
    required this.articles,
    required this.onArticleTap,
  });

  final List<NewsArticleEntity> articles;
  final ValueChanged<NewsArticleEntity> onArticleTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: articles.isEmpty
            ? const Center(child: Text('Здесь пока нет избранных новостей'))
            : CustomScrollView(
                slivers: [
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(24, 28, 24, 20),
                      child: Text(
                        'Избранное',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 18,
                            mainAxisSpacing: 24,
                            mainAxisExtent: 366,
                          ),
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final article = articles[index];
                        return ArticleTile(
                          article: article,
                          onTap: () => onArticleTap(article),
                        );
                      }, childCount: articles.length),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
