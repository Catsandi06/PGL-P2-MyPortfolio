import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const MyApp());
}

final _router = GoRouter(
  routes: [
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Mi portfolio',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: _router,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Inicio'),
      ),
      drawer: const PortfolioDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            const Text('Has pulsado el botón este número de veces:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Incrementar',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ContentPage extends StatelessWidget {
  const ContentPage({
    required this.title,
    required this.icon,
    required this.description,
    super.key,
  });

  final String title;
  final IconData icon;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      drawer: const PortfolioDrawer(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 72),
              const SizedBox(height: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),
              Text(
                description,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PortfolioDrawer extends StatelessWidget {
  const PortfolioDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).uri.path;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: Text(
              'Mi portfolio',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          _DrawerItem(
            icon: Icons.home_outlined,
            label: 'Inicio',
            location: '/',
            selected: currentLocation == '/',
          ),
          _DrawerItem(
            icon: Icons.person_outline,
            label: 'Sobre mí',
            location: '/sobre-mi',
            selected: currentLocation == '/sobre-mi',
          ),
          _DrawerItem(
            icon: Icons.work_outline,
            label: 'Proyectos',
            location: '/proyectos',
            selected: currentLocation == '/proyectos',
          ),
          _DrawerItem(
            icon: Icons.mail_outline,
            label: 'Contacto',
            location: '/contacto',
            selected: currentLocation == '/contacto',
          ),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.location,
    required this.selected,
  });

  final IconData icon;
  final String label;
  final String location;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      selected: selected,
      onTap: () {
        Navigator.of(context).pop();
        context.go(location);
      },
    );
  }
}
