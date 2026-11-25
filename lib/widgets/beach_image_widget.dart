import 'dart:typed_data';

import 'package:flutter/material.dart';

/// Widget que muestra la imagen de una playa con fallback según la categoría.
class BeachImageWidget extends StatelessWidget {
  /// Bytes de la imagen seleccionada desde el dispositivo (opcional).
  final Uint8List? imageBytes;

  /// URL de la imagen (opcional).
  final String imageUrl;

  /// Categoría de la playa para determinar la imagen de fallback.
  final String category;

  /// Tamaño de la imagen.
  final double size;

  const BeachImageWidget({
    super.key,
    this.imageBytes,
    required this.imageUrl,
    required this.category,
    this.size = 68,
  });

  /// Devuelve la imagen de fallback según la categoría de la playa.
  static String fallbackImageForCategory(String category) => switch (category) {
    'Playa urbana' || 'Playa familiar' => 'assets/images/home_bg.jpg',
    _ => 'assets/images/Sandi_proto.jpg',
  };

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: imageBytes != null
          ? Image.memory(
              imageBytes!,
              width: size,
              height: size,
              fit: BoxFit.cover,
            )
          : imageUrl.isEmpty
          ? Image.asset(
              fallbackImageForCategory(category),
              width: size,
              height: size,
              fit: BoxFit.cover,
            )
          : Image.network(
              imageUrl,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Image.asset(
                fallbackImageForCategory(category),
                width: size,
                height: size,
                fit: BoxFit.cover,
              ),
            ),
    );
  }
}
