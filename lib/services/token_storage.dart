import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Servicio dedicado al almacenamiento seguro del token JWT
class TokenStorage {
  static const String _tokenKey = 'jwt_token';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Guarda el token de forma segura
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  /// Obtiene el token guardado
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  /// Elimina el token guardado
  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }
}
