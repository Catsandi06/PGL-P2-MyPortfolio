import 'package:flutter/material.dart';

import 'router/app_router.dart';

// Punto de entrada de la aplicación Flutter.
void main() {
  runApp(const MyApp());
}

// Configuración global de la aplicación: tema y navegación.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Mi portfolio',
      theme: ThemeData(
        // Color principal compartido por el drawer y las pantallas.
        colorScheme: .fromSeed(seedColor: const Color(0xFF2A9D8F)),
      ),
      routerConfig: appRouter,
    );
  }
}
