import '../models/beach.dart';

/// Repository que es la fuente de verdad para los datos de las playas.
/// Según la documentación oficial de Flutter, los repositories son la fuente
/// de verdad del modelo de datos y manejan las operaciones de persistencia.
class PlayasRepository {
  /// Lista mutable de playas. En el futuro, esta lista podría reemplazarse
  /// por una base de datos (Hive, SQLite) o una API sin afectar al ViewModel.
  final List<Beach> _beaches = [
    const Beach(
      name: 'Playa de Las Canteras',
      description: 'Una playa urbana para pasear y desconectar.',
      category: 'Playa urbana',
      imageUrl: '',
      isClean: true,
      approximatePeople: 120,
    ),
    const Beach(
      name: 'Playa de Maspalomas',
      description: 'Dunas, arena dorada y vistas al océano.',
      category: 'Playa natural',
      imageUrl: '',
      isClean: true,
      approximatePeople: 75,
    ),
  ];

  /// Devuelve la lista completa de playas.
  List<Beach> getBeaches() => List.unmodifiable(_beaches);

  /// Añade una nueva playa al final de la lista.
  void addBeach(Beach beach) {
    _beaches.add(beach);
  }

  /// Elimina la playa en la posición indicada.
  void deleteBeach(int index) {
    _beaches.removeAt(index);
  }

  /// Elimina todas las playas de la lista.
  void deleteAllBeaches() {
    _beaches.clear();
  }
}
