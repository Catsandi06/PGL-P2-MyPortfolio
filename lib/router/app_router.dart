import 'package:go_router/go_router.dart';

import '../pages/portfolio_page.dart';
import '../pages/crud_playas_page.dart';
import '../pages/welcome_page.dart';

// Define las pantallas accesibles desde el drawer.
final appRouter = GoRouter(
  // La aplicación comienza mostrando la pantalla de bienvenida.
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
