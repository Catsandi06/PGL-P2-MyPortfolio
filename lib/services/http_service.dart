import 'package:http/http.dart' as http;
import 'dart:convert';

/// Servicio genérico para hacer peticiones HTTP a la API
class HttpService {
  static const String _baseUrl = 'https://my-users-api.onrender.com/users';

  /// Hace una petición POST a la API
  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);
      return {
        'statusCode': response.statusCode,
        'data': data,
      };
    } catch (e) {
      return {
        'statusCode': 0,
        'data': {'message': 'Error de conexión: $e'},
      };
    }
  }

  /// Hace una petición GET a la API con token de autenticación
  Future<Map<String, dynamic>> getWithAuth(String endpoint, String token) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);
      return {
        'statusCode': response.statusCode,
        'data': data,
      };
    } catch (e) {
      return {
        'statusCode': 0,
        'data': {'message': 'Error de conexión: $e'},
      };
    }
  }
}
