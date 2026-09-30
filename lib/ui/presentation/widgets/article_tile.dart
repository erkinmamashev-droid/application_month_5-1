import 'package:flutter/material.dart';
import 'package:news_app/domain/entity/news_article_entity.dart';

class ArticleTile extends StatelessWidget {
  const ArticleTile({super.key, required this.article, required this.onTap});

  final NewsArticleEntity article;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: AspectRatio(
                aspectRatio: 0.88,
                child: article.urlToImage.isEmpty
                    ? const _ImagePlaceholder()
                    : Image.network(
                        article.urlToImage,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => const _ImagePlaceholder(),
                      ),
              ),
            ),
            const SizedBox(height: 11),
            Text(
              article.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 5),
            Expanded(
              child: Text(
                article.description.isEmpty
                    ? 'Откройте новость, чтобы узнать подробности.'
                    : article.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF62645F),
                  height: 1.35,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              article.author,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.labelMedium?.copyWith(
                color: const Color(0xFF315C55),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              _formatDate(article.publishedAt),
              style: textTheme.labelSmall?.copyWith(
                color: const Color(0xFF888A85),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Color(0xFFE9EBE7),
      child: Center(
        child: Icon(Icons.image_outlined, color: Color(0xFF8A8E88), size: 32),
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
