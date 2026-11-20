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
    
    // Si ya está en login o register, no redirigir
    if (path == '/login' || path == '/register') return null;
    
    // Verificar si el usuario está autenticado
    final authenticated = await _isAuthenticated();
    
    // Si no está autenticado, redirigir a login
    if (!authenticated) return '/login';
    
    // Si está autenticado y intenta acceder a login, redirigir a bienvenida
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
