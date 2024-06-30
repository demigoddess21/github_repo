import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_repo/bloc/github_service.dart';
import 'bloc/repository_bloc.dart';
import 'screens/home_screen.dart';

void main() {
  final gitHubService =
      GitHubService('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');

  runApp(
    MyApp(gitHubService: gitHubService),
  );
}

class MyApp extends StatelessWidget {
  final GitHubService gitHubService;

  MyApp({required this.gitHubService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GitHub Repositories',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFF24292E), // GitHub dark mode background color
        scaffoldBackgroundColor:
            Color(0xFF181A1B), // GitHub dark mode canvas color
        appBarTheme: AppBarTheme(
          color: Color(0xFF24292E),
          elevation: 0,
          titleTextStyle: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        textTheme: TextTheme(
          bodyLarge:
              TextStyle(color: Colors.white), // Text color for large text
          bodyMedium:
              TextStyle(color: Colors.white70), // Text color for medium text
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Color(0xFF0366d6), // Accent color for links and buttons
          surface: Color(0xFF1F2325), // Surface color for cards and lists
          onSurface: Colors.white, // Text color on surface
        ),
      ),
      home: BlocProvider(
        create: (context) => RepositoryBloc(gitHubService),
        child: HomeScreen(),
      ),
    );
  }
}
