import 'package:flutter/material.dart';

/// Card con gradiente que muestra el resumen de playas guardadas y un botón
/// para borrar toda la lista.
class BeachesSummaryCard extends StatelessWidget {
  /// Número de playas guardadas.
  final int beachCount;
  
  /// Acción para borrar todas las playas.
  final VoidCallback? onDeleteAll;
  
  /// Color principal del gradiente.
  final Color primaryColor;
  
  /// Color secundario del gradiente.
  final Color secondaryColor;
  
  /// Color de acento para el badge.
  final Color accentColor;
  
  const BeachesSummaryCard({
    super.key,
    required this.beachCount,
    required this.onDeleteAll,
    this.primaryColor = const Color(0xFF2A9D8F),
    this.secondaryColor = const Color(0xFF237A70),
    this.accentColor = const Color(0xFFC9502B),
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: EdgeInsets.zero,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor, secondaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.beach_access,
                    color: Colors.white,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Playas guardadas',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Badge(
                    label: Text('$beachCount'),
                    backgroundColor: accentColor,
                    textColor: Colors.white,
                    child: const Icon(
                      Icons.location_on_outlined,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Organiza tus playas favoritas y consulta su estado.',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: onDeleteAll,
                icon: const Icon(Icons.delete_sweep_outlined),
                label: const Text('Borrar toda la lista'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white70),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
