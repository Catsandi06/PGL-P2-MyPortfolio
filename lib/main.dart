import 'package:flutter/material.dart';

import 'router/app_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Mi portfolio',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: const Color(0xFF5E7A80)),
      ),
      routerConfig: appRouter,
    );
  }
}
