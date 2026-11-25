import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:pgl_p2_myportfolio/pages/crud_playas_page.dart';
import 'package:pgl_p2_myportfolio/pages/portfolio_page.dart';
import 'package:pgl_p2_myportfolio/pages/welcome_page.dart';
import 'package:pgl_p2_myportfolio/main.dart';

Widget _buildNavigationTestApp() {
  final router = GoRouter(
    initialLocation: '/bienvenida',
    routes: [
      GoRoute(
        path: '/bienvenida',
        builder: (context, state) => const WelcomePage(),
      ),
      GoRoute(
        path: '/portfolio',
        builder: (context, state) => const PortfolioPage(),
      ),
      GoRoute(
        path: '/crud_playas',
        builder: (context, state) => const CrudPlayasPage(),
      ),
    ],
  );

  return MaterialApp.router(routerConfig: router);
}

void main() {
  testWidgets('muestra el login al iniciar la aplicación', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Iniciar Sesión'), findsNWidgets(2));
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Contraseña'), findsOneWidget);
    expect(find.byTooltip('Abrir menú'), findsNothing);
  });

  testWidgets('el drawer navega a la lista de playas', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_buildNavigationTestApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Abrir menú'));
    await tester.pumpAndSettle();

    expect(find.text('Bienvenida'), findsOneWidget);
    expect(find.text('Portfolio'), findsOneWidget);
    expect(find.text('Lista de Playas'), findsOneWidget);
    expect(find.text('Cerrar Sesión'), findsOneWidget);
    expect(find.text('Sobre mí'), findsNothing);
    expect(find.text('Proyectos'), findsNothing);
    expect(find.text('Contacto'), findsNothing);

    await tester.tap(find.text('Lista de Playas'));
    await tester.pumpAndSettle();

    expect(find.text('Mis playas'), findsOneWidget);
    expect(find.text('Playa de Las Canteras'), findsOneWidget);
  });

  testWidgets('abre el portfolio con hobbies y repositorio', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_buildNavigationTestApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Abrir menú'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Portfolio'));
    await tester.pumpAndSettle();

    expect(find.text('Este es mi portfolio'), findsOneWidget);
    expect(find.text('La informática'), findsOneWidget);
    expect(find.text('Los gatos'), findsOneWidget);

    await tester.tap(find.text('Mi repositorio'));
    await tester.pumpAndSettle();

    expect(
      find.text('¡Sandi Proto, el mejor gato programador!'),
      findsOneWidget,
    );

    await tester.tap(find.byTooltip('Abrir menú'));
    await tester.pumpAndSettle();
    expect(find.text('Bienvenida'), findsOneWidget);
    expect(find.text('Portfolio'), findsNWidgets(2));
  });
}
