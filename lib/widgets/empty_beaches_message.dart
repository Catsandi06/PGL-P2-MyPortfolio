import 'package:flutter/material.dart';

/// Mensaje que se muestra cuando la lista de playas está vacía.
class EmptyBeachesMessage extends StatelessWidget {
  const EmptyBeachesMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 12),
            const Text(
              'No hay playas todavía.\nPulsa «Añadir playa» para crear una.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
