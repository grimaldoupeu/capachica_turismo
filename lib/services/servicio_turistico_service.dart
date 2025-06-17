import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/servicio_turistico.dart';

class ServicioTuristicoService {
  static const String _baseUrl = 'http://112.138.0.108:8080/api';
  static const String _endpoint = '/servicios-turisticos'; // Asumiendo este endpoint

  Future<List<ServicioTuristico>> getServiciosTuristicos() async {
    final response = await http.get(Uri.parse('$_baseUrl$_endpoint'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) => ServicioTuristico.fromMap(json)).toList();
    } else {
      throw Exception('Failed to load servicios turisticos: ${response.statusCode}');
    }
  }

  Future<ServicioTuristico> getServicioTuristicoById(String id) async {
    final response = await http.get(Uri.parse('$_baseUrl$_endpoint/$id'));

    if (response.statusCode == 200) {
      return ServicioTuristico.fromJson(utf8.decode(response.bodyBytes));
    } else if (response.statusCode == 404) {
      throw Exception('Servicio turistico not found: $id');
    }
    else {
      throw Exception('Failed to load servicio turistico $id: ${response.statusCode}');
    }
  }

  Future<ServicioTuristico> createServicioTuristico(ServicioTuristico servicio) async {
    final response = await http.post(
      Uri.parse('$_baseUrl$_endpoint'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8', // Corregido UTF-TFs a UTF-8
      },
      body: servicio.toJson(),
    );

    if (response.statusCode == 201) { // 201 Created
      return ServicioTuristico.fromJson(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Failed to create servicio turistico: ${response.statusCode} ${response.body}');
    }
  }

  Future<ServicioTuristico> updateServicioTuristico(String id, ServicioTuristico servicio) async {
    final response = await http.put(
      Uri.parse('$_baseUrl$_endpoint/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: servicio.toJson(),
    );

    if (response.statusCode == 200) {
      return ServicioTuristico.fromJson(utf8.decode(response.bodyBytes));
    } else if (response.statusCode == 404) {
       throw Exception('Servicio turistico not found for update: $id');
    }
    else {
      throw Exception('Failed to update servicio turistico $id: ${response.statusCode} ${response.body}');
    }
  }

  Future<void> deleteServicioTuristico(String id) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl$_endpoint/$id'),
    );

    if (response.statusCode == 200 || response.statusCode == 204) { // 204 No Content
      // Eliminación exitosa
      return;
    } else if (response.statusCode == 404) {
       throw Exception('Servicio turistico not found for delete: $id');
    }
    else {
      throw Exception('Failed to delete servicio turistico $id: ${response.statusCode}');
    }
  }
}
