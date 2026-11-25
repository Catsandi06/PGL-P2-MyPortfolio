import 'package:flutter/material.dart';

import '../models/beach.dart';
import '../repositories/playas_repository.dart';

/// ViewModel que pertenece a la vista de CRUD de playas.
/// Según la documentación oficial de Flutter, un ViewModel conoce a uno o más
/// repositories y proporciona el estado y los comandos que la vista necesita.
class PlayasViewModel extends ChangeNotifier {
  final PlayasRepository _repository;

  /// Mensaje de feedback para mostrar en la interfaz (SnackBars).
  String? _feedbackMessage;

  String? get feedbackMessage => _feedbackMessage;

  /// Constructor que acepta un repository (por defecto crea uno nuevo).
  /// Esto facilita el testing: se puede inyectar un repository mock.
  PlayasViewModel({PlayasRepository? repository})
      : _repository = repository ?? PlayasRepository() {
    _loadBeaches();
  }

  /// Lista actual de playas, obtenida del repository.
  late List<Beach> _beaches;

  List<Beach> get beaches => _beaches;

  /// Carga las playas desde el repository.
  void _loadBeaches() {
    _beaches = _repository.getBeaches();
  }

  /// Añade una nueva playa y actualiza el estado.
  void addBeach(Beach beach) {
    _repository.addBeach(beach);
    _loadBeaches();
    _feedbackMessage = '«${beach.name}» añadida a la lista';
    notifyListeners();
  }

  /// Elimina la playa en la posición indicada y actualiza el estado.
  void deleteBeach(int index) {
    final deletedBeach = _beaches[index];
    _repository.deleteBeach(index);
    _loadBeaches();
    _feedbackMessage = '«${deletedBeach.name}» eliminada';
    notifyListeners();
  }

  /// Elimina todas las playas y actualiza el estado.
  void deleteAllBeaches() {
    _repository.deleteAllBeaches();
    _loadBeaches();
    _feedbackMessage = 'Se han borrado todas las playas';
    notifyListeners();
  }

  /// Limpia el mensaje de feedback después de que la vista lo haya mostrado.
  void clearFeedback() {
    _feedbackMessage = null;
    notifyListeners();
  }
}
