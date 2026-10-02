import 'package:flutter/material.dart';
import 'package:news_app/core/di/injection.dart';
import 'package:news_app/ui/bloc/news_bloc.dart';
import 'package:news_app/ui/presentation/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage(createNewsBloc: () => getIt<NewsBloc>()));
  }
}
