import 'package:flutter/material.dart';
import 'package:news_app/core/services/app_preferences.dart';
import 'package:news_app/ui/presentation/screens/auth_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key, required this.homeBuilder});

  final WidgetBuilder homeBuilder;

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  static const _pages = [
    (
      icon: Icons.public,
      title: 'Новости со всего мира',
      description: 'Следите за важными событиями и новостями в одном месте.',
    ),
    (
      icon: Icons.search,
      title: 'Находите интересное',
      description: 'Ищите публикации по темам, которые важны именно вам.',
    ),
    (
      icon: Icons.favorite_border,
      title: 'Сохраняйте на потом',
      description: 'Добавляйте понравившиеся статьи в избранное.',
    ),
  ];

  final _controller = PageController();
  final _preferences = AppPreferences();
  int _page = 0;
  bool _isCompleting = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finishOnboarding() async {
    setState(() {
      _isCompleting = true;
      _error = null;
    });
    try {
      await _preferences.completeOnboarding();
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => AuthPage(homeBuilder: widget.homeBuilder),
        ),
      );
    } catch (error) {
      if (mounted) {
        setState(() {
          _isCompleting = false;
          _error = 'Не удалось сохранить настройки: $error';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _isCompleting ? null : _finishOnboarding,
                  child: const Text('Пропустить'),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _pages.length,
                  onPageChanged: (index) => setState(() => _page = index),
                  itemBuilder: (context, index) {
                    final item = _pages[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          item.icon,
                          size: 112,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 36),
                        Text(
                          item.title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          item.description,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _page == index ? 22 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _page == index
                          ? Theme.of(context).colorScheme.primary
                          : Colors.black26,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 16),
                Text(_error!, textAlign: TextAlign.center),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isCompleting
                      ? null
                      : _page == _pages.length - 1
                      ? _finishOnboarding
                      : () => _controller.nextPage(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                        ),
                  child: _isCompleting
                      ? const CircularProgressIndicator()
                      : Text(
                          _page == _pages.length - 1 ? 'Начать' : 'Продолжить',
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
