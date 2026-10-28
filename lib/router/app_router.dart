import 'package:go_router/go_router.dart';

import '../pages/content_page.dart';
import '../pages/welcome_page.dart';

final appRouter = GoRouter(
  initialLocation: '/bienvenida',
  routes: [
    GoRoute(
      path: '/bienvenida',
      builder: (context, state) => const WelcomePage(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const ContentPage(),
    ),
  ],
);
