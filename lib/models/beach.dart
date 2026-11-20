import 'dart:typed_data';

/// Categorías disponibles para clasificar cada playa.
const beachCategories = <String>[
  'Playa urbana',
  'Playa natural',
  'Playa familiar',
  'Playa deportiva',
];

/// Modelo inmutable que representa una playa creada desde el formulario.
class Beach {
  const Beach({
    required this.name,
    required this.description,
    required this.category,
    required this.imageUrl,
    this.imageBytes,
    required this.isClean,
    required this.approximatePeople,
  });

  final String name;
  final String description;
  final String category;
  final String imageUrl;
  final Uint8List? imageBytes;
  final bool isClean;
  final int approximatePeople;
}
