import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/hospedaje.dart'; // Asegúrate que el modelo Hospedaje esté importado

class HospedajeService {
  // Usar la misma baseUrl que para ServicioTuristicoService o definirla globalmente
  static const String _baseUrl = 'http://112.138.0.108:8080/api';
  static const String _endpoint = '/hospedajes'; // Asumiendo este endpoint para hospedajes

  Future<List<Hospedaje>> getHospedajes() async {
    final response = await http.get(Uri.parse('$_baseUrl$_endpoint'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) => Hospedaje.fromMap(json)).toList();
    } else {
      throw Exception('Failed to load hospedajes: ${response.statusCode} ${response.body}');
    }
  }

  Future<Hospedaje> getHospedajeById(String id) async {
    final response = await http.get(Uri.parse('$_baseUrl$_endpoint/$id'));

    if (response.statusCode == 200) {
      return Hospedaje.fromJson(utf8.decode(response.bodyBytes));
    } else if (response.statusCode == 404) {
      throw Exception('Hospedaje not found: $id');
    }
    else {
      throw Exception('Failed to load hospedaje $id: ${response.statusCode} ${response.body}');
    }
  }

  Future<Hospedaje> createHospedaje(Hospedaje hospedaje) async {
    final response = await http.post(
      Uri.parse('$_baseUrl$_endpoint'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: hospedaje.toJson(),
    );

    if (response.statusCode == 201) { // 201 Created
      return Hospedaje.fromJson(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Failed to create hospedaje: ${response.statusCode} ${response.body}');
    }
  }

  Future<Hospedaje> updateHospedaje(String id, Hospedaje hospedaje) async {
    final response = await http.put(
      Uri.parse('$_baseUrl$_endpoint/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: hospedaje.toJson(),
    );

    if (response.statusCode == 200) {
      return Hospedaje.fromJson(utf8.decode(response.bodyBytes));
    } else if (response.statusCode == 404) {
       throw Exception('Hospedaje not found for update: $id');
    }
    else {
      throw Exception('Failed to update hospedaje $id: ${response.statusCode} ${response.body}');
    }
  }

  Future<void> deleteHospedaje(String id) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl$_endpoint/$id'),
    );

    if (response.statusCode == 200 || response.statusCode == 204) { // 204 No Content
      // Eliminación exitosa
      return;
    } else if (response.statusCode == 404) {
       throw Exception('Hospedaje not found for delete: $id');
    }
    else {
      throw Exception('Failed to delete hospedaje $id: ${response.statusCode} ${response.body}');
    }
  }
}
