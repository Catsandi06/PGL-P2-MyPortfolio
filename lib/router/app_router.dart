import 'package:go_router/go_router.dart';

import '../pages/portfolio_page.dart';
import '../pages/crud_playas_page.dart';
import '../pages/welcome_page.dart';
import '../pages/login_page.dart';
import '../pages/register_page.dart';
import '../services/auth_service.dart';

final _authService = AuthService();

// Verifica si el usuario tiene un token válido
Future<bool> _isAuthenticated() async {
  final token = await _authService.getToken();
  if (token == null) return false;
  return _authService.checkToken(token);
}

// Define las pantallas accesibles desde el drawer.
final appRouter = GoRouter(
  // La aplicación comienza mostrando la pantalla de login.
  initialLocation: '/login',
  redirect: (context, state) async {
    final path = state.uri.path;
    
    // La pantalla de registro es siempre accesible
    if (path == '/register') return null;

    final authenticated = await _isAuthenticated();

    // Sin token válido solo se puede ver login
    if (!authenticated) return path == '/login' ? null : '/login';

    // Con token válido, login redirige a bienvenida
    if (path == '/login') return '/bienvenida';

    return null;
  },
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),
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
