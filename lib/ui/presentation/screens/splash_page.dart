import 'package:flutter/material.dart';
import 'package:news_app/core/services/app_preferences.dart';
import 'package:news_app/ui/presentation/screens/auth_page.dart';
import 'package:news_app/ui/presentation/screens/onboarding_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key, required this.homeBuilder});

  final WidgetBuilder homeBuilder;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final _preferences = AppPreferences();
  Object? _error;

  @override
  void initState() {
    super.initState();
    _routeFromSavedState();
  }

  Future<void> _routeFromSavedState() async {
    setState(() => _error = null);
    try {
      final onboardingComplete = await _preferences.hasCompletedOnboarding();
      if (!mounted) return;

      if (!onboardingComplete) {
        _replaceWith((_) => OnboardingPage(homeBuilder: widget.homeBuilder));
        return;
      }

      final authenticated = await _preferences.isAuthenticated();
      if (!mounted) return;

      _replaceWith(
        authenticated
            ? widget.homeBuilder
            : (_) => AuthPage(homeBuilder: widget.homeBuilder),
      );
    } catch (error) {
      if (mounted) setState(() => _error = error);
    }
  }

  void _replaceWith(WidgetBuilder pageBuilder) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute<void>(builder: pageBuilder));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: _error == null
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.flutter_dash, size: 100, color: Colors.white),
                  SizedBox(height: 24),
                  Text(
                    'Geeks Mobile App',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 40),
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ],
              )
            : Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Не удалось загрузить настройки: $_error',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: _routeFromSavedState,
                      child: const Text('Повторить'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
