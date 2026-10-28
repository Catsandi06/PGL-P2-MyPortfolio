import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
