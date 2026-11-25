import 'http_service.dart';
import 'token_storage.dart';

/// Servicio de autenticación que encapsula la lógica de negocio
/// Usa HttpService para las peticiones y TokenStorage para el almacenamiento
class AuthService {
  final HttpService _httpService = HttpService();
  final TokenStorage _tokenStorage = TokenStorage();

  /// Registra un nuevo usuario
  /// Devuelve un mapa con 'success' (bool) y 'message' (String)
  Future<Map<String, dynamic>> register(String fullName, String email, String pwd) async {
    final result = await _httpService.post('/register', {
      'fullName': fullName,
      'email': email,
      'pwd': pwd,
    });

    if (result['statusCode'] == 201) {
      return {
        'success': true,
        'message': result['data']['message'] ?? 'Registro exitoso',
      };
    } else {
      return {
        'success': false,
        'message': result['data']['message'] ?? 'Error en el registro',
      };
    }
  }

  /// Inicia sesión con email y contraseña
  /// Devuelve el token si es exitoso, o null con un mensaje de error
  Future<Map<String, dynamic>> login(String email, String pwd) async {
    final result = await _httpService.post('/login', {
      'email': email,
      'pwd': pwd,
    });

    if (result['statusCode'] == 200) {
      final token = result['data']['token'];
      await _tokenStorage.saveToken(token);
      return {
        'success': true,
        'message': result['data']['message'] ?? 'Login exitoso',
        'token': token,
      };
    } else {
      return {
        'success': false,
        'message': result['data']['message'] ?? 'Error en el inicio de sesión',
      };
    }
  }

  /// Verifica si un token es válido
  Future<bool> checkToken(String token) async {
    final result = await _httpService.getWithAuth('/check-token', token);
    return result['statusCode'] == 200;
  }

  /// Obtiene el mensaje de bienvenida de la API
  Future<Map<String, dynamic>> getWelcomeMessage(String token) async {
    final result = await _httpService.getWithAuth('/welcome', token);

    if (result['statusCode'] == 200) {
      return {
        'success': true,
        'message': result['data']['message'] ?? 'Bienvenido',
      };
    } else {
      return {
        'success': false,
        'message': result['data']['message'] ?? 'Error al obtener el mensaje',
      };
    }
  }

  /// Guarda el token de forma segura
  Future<void> saveToken(String token) async {
    await _tokenStorage.saveToken(token);
  }

  /// Obtiene el token guardado
  Future<String?> getToken() async {
    return await _tokenStorage.getToken();
  }

  /// Elimina el token guardado
  Future<void> deleteToken() async {
    await _tokenStorage.deleteToken();
  }
}
