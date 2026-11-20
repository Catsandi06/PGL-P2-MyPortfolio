import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  LocalStorageService({this._preferences});

  static const _selectedBeachKey = 'settings.selected_beach';
  static const _messageKey = 'settings.message';

  SharedPreferences? _preferences;

  Future<SharedPreferences> _ensureInitialized() async {
    _preferences ??= await SharedPreferences.getInstance();
    return _preferences!;
  }

  Future<String?> getSelectedBeach() async {
    final prefs = await _ensureInitialized();
    return prefs.getString(_selectedBeachKey);
  }

  Future<String?> getMessage() async {
    final prefs = await _ensureInitialized();
    return prefs.getString(_messageKey);
  }

  Future<void> saveSettings({
    required String selectedBeach,
    required String message,
  }) async {
    final prefs = await _ensureInitialized();
    await Future.wait([
      prefs.setString(_selectedBeachKey, selectedBeach),
      prefs.setString(_messageKey, message),
    ]);
  }
}
