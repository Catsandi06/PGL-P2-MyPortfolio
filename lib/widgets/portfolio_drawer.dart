import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PortfolioDrawer extends StatelessWidget {
  const PortfolioDrawer({super.key});

  static const _teal = Color(0xFF5E7A80);
  static const _orange = Color(0xFFC9502B);

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).uri.path;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: _teal,
            ),
            child: Text(
              'Mi portfolio',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          _DrawerItem(
            icon: Icons.waving_hand_outlined,
            label: 'Bienvenida',
            location: '/bienvenida',
            selected: currentLocation == '/bienvenida',
          ),
          _DrawerItem(
            icon: Icons.work_outline,
            label: 'Portfolio',
            location: '/',
            selected: currentLocation == '/',
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
      iconColor: selected ? PortfolioDrawer._orange : PortfolioDrawer._teal,
      textColor: selected ? PortfolioDrawer._orange : PortfolioDrawer._teal,
      selectedColor: PortfolioDrawer._orange,
      selectedTileColor: PortfolioDrawer._orange.withValues(alpha: 0.12),
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
