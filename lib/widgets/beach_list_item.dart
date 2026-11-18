import 'package:flutter/material.dart';

import '../models/beach.dart';
import 'beach_image_widget.dart';

/// Widget que muestra una playa individual en la lista con imagen, información
/// y botón de borrar.
class BeachListItem extends StatelessWidget {
  /// Playa a mostrar.
  final Beach beach;
  
  /// Acción para borrar esta playa.
  final VoidCallback onDelete;
  
  /// Color del botón de borrar.
  final Color deleteButtonColor;
  
  const BeachListItem({
    super.key,
    required this.beach,
    required this.onDelete,
    this.deleteButtonColor = const Color(0xFFC9502B),
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: BeachImageWidget(
          imageBytes: beach.imageBytes,
          imageUrl: beach.imageUrl,
          category: beach.category,
        ),
        title: Text(
          beach.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            '${beach.description}\n'
            'Categoría: ${beach.category} · '
            '${beach.isClean ? 'Limpia' : 'Pendiente de limpieza'}\n'
            'Aforo aproximado: ${beach.approximatePeople} personas',
          ),
        ),
        isThreeLine: true,
        trailing: IconButton(
          onPressed: onDelete,
          tooltip: 'Borrar ${beach.name}',
          color: deleteButtonColor,
          icon: const Icon(Icons.delete_outline),
        ),
      ),
    );
  }
}
