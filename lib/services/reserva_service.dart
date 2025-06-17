import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/reserva.dart';

class ReservaService {
  static const String _baseUrl = 'http://112.138.0.108:8080/api';
  static const String _endpoint = '/reservas'; // Asumiendo este endpoint para reservas

  Future<List<Reserva>> getReservas() async {
    final response = await http.get(Uri.parse('$_baseUrl$_endpoint'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) => Reserva.fromMap(json)).toList();
    } else {
      throw Exception('Failed to load reservas: ${response.statusCode} ${response.body}');
    }
  }

  Future<Reserva> getReservaById(String id) async {
    final response = await http.get(Uri.parse('$_baseUrl$_endpoint/$id'));

    if (response.statusCode == 200) {
      return Reserva.fromJson(utf8.decode(response.bodyBytes));
    } else if (response.statusCode == 404) {
      throw Exception('Reserva not found: $id');
    }
    else {
      throw Exception('Failed to load reserva $id: ${response.statusCode} ${response.body}');
    }
  }

  Future<Reserva> createReserva(Reserva reserva) async {
    final response = await http.post(
      Uri.parse('$_baseUrl$_endpoint'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: reserva.toJson(),
    );

    if (response.statusCode == 201) { // 201 Created
      return Reserva.fromJson(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Failed to create reserva: ${response.statusCode} ${response.body}');
    }
  }

  Future<Reserva> updateReserva(String id, Reserva reserva) async {
    final response = await http.put(
      Uri.parse('$_baseUrl$_endpoint/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: reserva.toJson(),
    );

    if (response.statusCode == 200) {
      return Reserva.fromJson(utf8.decode(response.bodyBytes));
    } else if (response.statusCode == 404) {
       throw Exception('Reserva not found for update: $id');
    }
    else {
      throw Exception('Failed to update reserva $id: ${response.statusCode} ${response.body}');
    }
  }

  Future<void> deleteReserva(String id) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl$_endpoint/$id'),
    );

    if (response.statusCode == 200 || response.statusCode == 204) { // 204 No Content
      return;
    } else if (response.statusCode == 404) {
       throw Exception('Reserva not found for delete: $id');
    }
    else {
      throw Exception('Failed to delete reserva $id: ${response.statusCode} ${response.body}');
    }
  }
}
