import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user.dart'; // Importar el modelo User
import 'package:http/http.dart' as http; // Descomentado
import 'dart:convert'; // Descomentado

class AuthService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  static const String _tokenKey = 'auth_token';
  // Asumimos que los endpoints de auth están bajo la misma API base
  static const String _apiBaseUrl = 'http://112.138.0.108:8080/api';
  static const String _authLoginPath = '/auth/login'; // Placeholder para tu endpoint de login
  // static const String _authLogoutPath = '/auth/logout'; // Placeholder
  // static const String _authMePath = '/auth/me'; // Placeholder


  Future<String?> getToken() async {
    try {
      return await _secureStorage.read(key: _tokenKey);
    } catch (e) {
      // Manejar el error, por ejemplo, si flutter_secure_storage no está disponible en la plataforma.
      print('Error al leer token de secure_storage: $e');
      return null;
    }
  }

  Future<void> saveToken(String token) async {
    try {
      await _secureStorage.write(key: _tokenKey, value: token);
    } catch (e) {
      print('Error al guardar token en secure_storage: $e');
    }
  }

  Future<void> deleteToken() async {
    try {
      await _secureStorage.delete(key: _tokenKey);
    } catch (e) {
      print('Error al eliminar token de secure_storage: $e');
    }
  }

  Future<User> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$_apiBaseUrl$_authLoginPath'), // USA TU ENDPOINT REAL
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(<String, String>{
        'username': username, // o 'email' según tu backend
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));

      // Asumimos que la respuesta tiene una estructura como:
      // { "token": "...", "user": { "id": 1, "username": "...", "email": "...", "isAdmin": true } }
      // o { "token": "...", "id": 1, "username": "...", "email": "...", "isAdmin": true }
      // Adapta esto a la estructura real de tu API.

      final token = data['token'] as String?;
      Map<String, dynamic>? userMap;

      if (data.containsKey('user') && data['user'] is Map) {
         userMap = data['user'] as Map<String, dynamic>;
      } else if (data.containsKey('id') && data.containsKey('username')) {
        // Si los datos del usuario están en el nivel raíz de la respuesta junto al token
        userMap = data;
      }

      if (token != null && userMap != null) {
        await saveToken(token);
        // Si tu User.fromMap espera 'isAdmin' pero tu API devuelve 'role': "ROLE_ADMIN",
        // necesitarás transformar 'role' a 'isAdmin' aquí antes de pasarlo a User.fromMap.
        // Ejemplo de transformación (si 'role' existe en userMap):
        // if (userMap.containsKey('role')) {
        //   userMap['isAdmin'] = (userMap['role'] == 'ROLE_ADMIN' || userMap['role'] == 'admin');
        // }
        return User.fromMap(userMap);
      } else {
        throw Exception('Respuesta de login inválida: token o datos de usuario no encontrados.');
      }
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      throw Exception('Credenciales incorrectas o no autorizado.');
    }
    else {
      throw Exception('Error de login: ${response.statusCode} - ${response.body}');
    }
  }

  Future<void> logout() async {
    // Opcional: Llamar a un endpoint de logout en el backend si existe.
    // final token = await getToken();
    // if (token != null) {
    //   try {
    //     await http.post(
    //       Uri.parse('$_apiBaseUrl$_authLogoutPath'), // USA TU ENDPOINT REAL
    //       headers: {
    //         'Content-Type': 'application/json; charset=UTF-8',
    //         'Authorization': 'Bearer $token',
    //       },
    //     );
    //   } catch (e) {
    //     print('Error en llamada a API de logout (se procederá a limpiar token local): $e');
    //   }
    // }
    await deleteToken(); // Siempre eliminar el token local
    print('AuthService: logout completado y token local eliminado.');
  }

  Future<User?> getCurrentUser() async {
    // Esta es una implementación SIMPLIFICADA.
    // Una implementación robusta llamaría a un endpoint /api/me para validar el token
    // y obtener datos frescos del usuario.
    final token = await getToken();
    if (token == null) {
      return null;
    }

    // --- INICIO SIMULACIÓN BASADA EN TOKEN (para mantener compatibilidad con la lógica anterior) ---
    // Esta parte debería ser reemplazada por una llamada a un endpoint /me o decodificación de JWT
    // si el token contiene la información del usuario de forma segura.
    print('AuthService: getCurrentUser (simulado basado en token) - Token encontrado: $token');
    if (token == 'fake_admin_jwt_token') { // Mantenemos la simulación para los tokens falsos
      return User(id: 1, username: 'admin', email: 'admin@example.com', isAdmin: true);
    } else if (token == 'fake_user_jwt_token') {
      return User(id: 2, username: 'user', email: 'user@example.com', isAdmin: false);
    }
    // --- FIN SIMULACIÓN ---

    // Si el token no es uno de los simulados, y no tenemos un endpoint /me implementado aquí,
    // no podemos determinar el usuario. En una app real, aquí iría la llamada al endpoint /me.
    // print('AuthService:getCurrentUser - Token real encontrado, pero no hay lógica para obtener usuario desde él sin /me endpoint.');
    // Por ahora, para que la app no rompa si se loguea con la API real y luego reinicia:
    // Podrías intentar decodificar el JWT aquí si es seguro y contiene los datos del usuario,
    // o simplemente devolver null y forzar un nuevo login si la sesión no se puede reconstruir sin /me.
    // Devolver null es más seguro si no se puede verificar el token/usuario.
    return null;
  }
}
