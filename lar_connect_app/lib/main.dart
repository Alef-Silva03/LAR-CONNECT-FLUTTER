import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app/router.dart';
import 'core/http_client.dart';
import 'features/auth/data/auth_repository.dart';

void main() {
  final repository = AuthRepository(dio);
  final router = buildRouter(repository);

  runApp(MyApp(router: router));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.router});

  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'LAR CONNECT',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}