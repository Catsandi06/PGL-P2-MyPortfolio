import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../pages/content_page.dart';
import '../pages/home_page.dart';
import '../pages/welcome_page.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/bienvenida',
      builder: (context, state) => const WelcomePage(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const MyHomePage(),
    ),
    GoRoute(
      path: '/sobre-mi',
      builder: (context, state) => const ContentPage(
        title: 'Sobre mí',
        icon: Icons.person_outline,
        description: 'Conoce mi experiencia, mis intereses y mi trayectoria.',
      ),
    ),
    GoRoute(
      path: '/proyectos',
      builder: (context, state) => const ContentPage(
        title: 'Proyectos',
        icon: Icons.work_outline,
        description: 'Una selección de proyectos en los que he trabajado.',
      ),
    ),
    GoRoute(
      path: '/contacto',
      builder: (context, state) => const ContentPage(
        title: 'Contacto',
        icon: Icons.mail_outline,
        description: 'Ponte en contacto conmigo para comenzar un proyecto.',
      ),
    ),
  ],
);
