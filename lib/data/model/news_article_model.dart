import 'package:news_app/domain/entity/news_article_entity.dart';

class NewsArticleModel {
  const NewsArticleModel({
    this.author,
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
  });

  final String? author;
  final String? title;
  final String? description;
  final String? url;
  final String? urlToImage;
  final String? publishedAt;
  final String? content;

  factory NewsArticleModel.fromJson(Map<String, dynamic> json) {
    return NewsArticleModel(
      author: json['author'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      url: json['url'] as String?,
      urlToImage: json['urlToImage'] as String?,
      publishedAt: json['publishedAt'] as String?,
      content: json['content'] as String?,
    );
  }

  static List<NewsArticleModel> fromJsonList(List<dynamic>? jsonList) {
    if (jsonList == null || jsonList.isEmpty) return [];

    return jsonList
        .map((e) => NewsArticleModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  NewsArticleEntity fromModelToEntity() {
    return NewsArticleEntity(
      author: author ?? "Нету автора",
      title: title ?? "",
      description: description ?? "",
      url: url ?? "",
      urlToImage: urlToImage ?? "",
      publishedAt: publishedAt ?? "",
      content: content ?? "",
    );
  }
}
