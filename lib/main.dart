import 'package:flutter/material.dart';
import 'package:news_app/core/di/injection.dart';
import 'package:news_app/domain/entity/news_article_entity.dart';
import 'package:news_app/ui/bloc/news_bloc.dart';
import 'package:news_app/ui/presentation/favorite_page.dart';
import 'package:news_app/ui/presentation/home_page.dart';
import 'package:news_app/ui/presentation/news_details_page.dart';
import 'package:news_app/ui/presentation/profile_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(createNewsBloc: () => getIt<NewsBloc>()),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.createNewsBloc});

  final NewsBloc Function() createNewsBloc;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final List<NewsArticleEntity> _favorites = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomePage(
            createNewsBloc: widget.createNewsBloc,
            onArticleTap: _openArticle,
          ),
          FavoritePage(articles: _favorites, onArticleTap: _openArticle),
          const ProfilePage(),
        ],
      ),
      bottomNavigationBar: _BottomNavigationBar(
        selectedIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }

  void _openArticle(NewsArticleEntity article) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => NewsDetailsPage(
          article: article,
          isFavorite: _favorites.any(
            (item) => _articleKey(item) == _articleKey(article),
          ),
          onToggleFavorite: () => _toggleFavorite(article),
        ),
      ),
    );
  }

  void _toggleFavorite(NewsArticleEntity article) {
    setState(() {
      final key = _articleKey(article);
      if (_favorites.any((item) => _articleKey(item) == key)) {
        _favorites.removeWhere((item) => _articleKey(item) == key);
      } else {
        _favorites.add(article);
      }
    });
  }
}

String _articleKey(NewsArticleEntity article) => article.url.isNotEmpty
    ? article.url
    : '${article.title}|${article.author}|${article.publishedAt}';

class _BottomNavigationBar extends StatelessWidget {
  const _BottomNavigationBar({
    required this.selectedIndex,
    required this.onTap,
  });

  final int selectedIndex;
  final ValueChanged<int> onTap;

  static const _items = [
    (icon: Icons.search, label: 'EXPLORE'),
    (icon: Icons.favorite_border, label: 'FAVOURITE'),
    (icon: Icons.menu, label: 'MENU'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        height: 66,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
        decoration: const BoxDecoration(
          color: Color(0xFFF7F7F7),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(_items.length, (index) {
            final item = _items[index];
            final isSelected = selectedIndex == index;

            return Material(
              color: isSelected ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(30),
              child: InkWell(
                onTap: () => onTap(index),
                borderRadius: BorderRadius.circular(30),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSelected ? 18 : 14,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(item.icon, size: 27, color: Colors.black87),
                      if (isSelected) ...[
                        const SizedBox(width: 10),
                        Text(
                          item.label,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
