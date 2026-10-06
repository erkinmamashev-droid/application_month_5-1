import 'package:flutter/material.dart';
import 'package:news_app/domain/entity/news_article_entity.dart';

class NewsDetailsPage extends StatefulWidget {
  const NewsDetailsPage({
    super.key,
    required this.article,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  final NewsArticleEntity article;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  @override
  State<NewsDetailsPage> createState() => _NewsDetailsPageState();
}

class _NewsDetailsPageState extends State<NewsDetailsPage> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final article = widget.article;
    final body = article.content.trim().isNotEmpty
        ? article.content.replaceAll(RegExp(r'\s*\[\+\d+ chars\]'), '')
        : article.description;

    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFA),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleFavorite,
        backgroundColor: Colors.white,
        foregroundColor: _isFavorite ? Colors.red : Colors.black87,
        tooltip: _isFavorite ? 'Удалить из избранного' : 'Добавить в избранное',
        child: Icon(
          _isFavorite ? Icons.favorite : Icons.favorite_border,
          size: 28,
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        tooltip: 'Назад',
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: AspectRatio(
                        aspectRatio: 1.15,
                        child: article.urlToImage.isEmpty
                            ? const _DetailsImagePlaceholder()
                            : Image.network(
                                article.urlToImage,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) =>
                                    const _DetailsImagePlaceholder(),
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      article.title,
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 9),
                    Text(
                      article.author,
                      style: textTheme.titleMedium?.copyWith(
                        color: const Color(0xFF62645F),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(height: 1, color: Color(0xFFDADBD7)),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 16,
                          color: Color(0xFF315C55),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatDate(article.publishedAt),
                          style: textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFF62645F),
                          ),
                        ),
                        const SizedBox(width: 20),
                        const Icon(
                          Icons.person_outline,
                          size: 18,
                          color: Color(0xFF315C55),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            article.author,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFF62645F),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Text(
                      'Кратко',
                      style: textTheme.titleMedium?.copyWith(
                        color: const Color(0xFF888A85),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      article.description.isEmpty
                          ? 'Для этой новости нет краткого описания.'
                          : article.description,
                      style: textTheme.bodyLarge?.copyWith(height: 1.55),
                    ),
                    if (body.isNotEmpty && body != article.description) ...[
                      const SizedBox(height: 26),
                      Text(
                        'Подробности',
                        style: textTheme.titleMedium?.copyWith(
                          color: const Color(0xFF888A85),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        body,
                        style: textTheme.bodyLarge?.copyWith(height: 1.55),
                      ),
                    ],
                    if (article.url.isNotEmpty) ...[
                      const SizedBox(height: 26),
                      const Divider(height: 1, color: Color(0xFFDADBD7)),
                      const SizedBox(height: 14),
                      Text(
                        'Источник: ${Uri.tryParse(article.url)?.host ?? article.url}',
                        style: textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF888A85),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleFavorite() {
    setState(() => _isFavorite = !_isFavorite);
    widget.onToggleFavorite();
  }
}

class _DetailsImagePlaceholder extends StatelessWidget {
  const _DetailsImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Color(0xFFE9EBE7),
      child: Center(
        child: Icon(Icons.image_outlined, color: Color(0xFF8A8E88), size: 40),
      ),
    );
  }
}

String _formatDate(String value) {
  final date = DateTime.tryParse(value)?.toLocal();
  if (date == null) return value;
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day.$month.${date.year}';
}
