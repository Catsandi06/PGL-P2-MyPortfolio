import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PortfolioDrawer extends StatelessWidget {
  const PortfolioDrawer({super.key});

  // Colores de marca usados en la cabecera y en las opciones seleccionadas.
  static const _teal = Color(0xFF5E7A80);
  static const _orange = Color(0xFFC9502B);

  @override
  Widget build(BuildContext context) {
    // Permite marcar la opción correspondiente a la ruta actual.
    final currentLocation = GoRouterState.of(context).uri.path;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // La cabecera identifica la aplicación y muestra el usuario activo.
          DrawerHeader(
            decoration: BoxDecoration(color: _teal),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Icono de la aplicación dentro de un fondo naranja.
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _orange,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.beach_access,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        'Playas Canarias',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // No usamos const porque Image.network se carga en ejecución.
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      // ClipOval recorta la imagen cuadrada con la misma forma
                      // circular que el avatar.
                      child: ClipOval(
                        child: Image.network(
                          'https://github.com/Catsandi06.png',
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                          // Si la imagen remota falla, mostramos un respaldo.
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.person, color: _teal, size: 30),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nichel',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Mi portfolio',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          _DrawerItem(
            // Cada opción lleva a una de las dos rutas principales.
            icon: Icons.waving_hand_outlined,
            label: 'Bienvenida',
            location: '/bienvenida',
            selected: currentLocation == '/bienvenida',
          ),
          _DrawerItem(
            icon: Icons.work_outline,
            label: 'Portfolio',
            location: '/portfolio',
            selected: currentLocation == '/portfolio',
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
    // El color y el fondo cambian para indicar qué pantalla está abierta.
    return ListTile(
      iconColor: selected ? PortfolioDrawer._orange : PortfolioDrawer._teal,
      textColor: selected ? PortfolioDrawer._orange : PortfolioDrawer._teal,
      selectedColor: PortfolioDrawer._orange,
      selectedTileColor: PortfolioDrawer._orange.withValues(alpha: 0.12),
      leading: Icon(icon),
      title: Text(label),
      selected: selected,
      onTap: () {
        // Cerramos el drawer antes de cambiar de ruta para no dejarlo abierto.
        Navigator.of(context).pop();
        // GoRouter cambia de pantalla conservando una navegación centralizada.
        context.go(location);
      },
    );
  }
}
