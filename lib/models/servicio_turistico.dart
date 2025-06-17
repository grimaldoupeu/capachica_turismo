import 'dart:convert';

import 'package:flutter/foundation.dart';

class ServicioTuristico {
  final String id;
  final String nombre;
  final String descripcion;
  final String ubicacion;
  final double precio;
  final String imagenUrl;
  final String horario;
  final List<String> diasDisponibles;
  final bool disponible;

  ServicioTuristico({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.ubicacion,
    required this.precio,
    required this.imagenUrl,
    required this.horario,
    required this.diasDisponibles,
    required this.disponible,
  });

  ServicioTuristico copyWith({
    String? id,
    String? nombre,
    String? descripcion,
    String? ubicacion,
    double? precio,
    String? imagenUrl,
    String? horario,
    List<String>? diasDisponibles,
    bool? disponible,
  }) {
    return ServicioTuristico(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      ubicacion: ubicacion ?? this.ubicacion,
      precio: precio ?? this.precio,
      imagenUrl: imagenUrl ?? this.imagenUrl,
      horario: horario ?? this.horario,
      diasDisponibles: diasDisponibles ?? this.diasDisponibles,
      disponible: disponible ?? this.disponible,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'ubicacion': ubicacion,
      'precio': precio,
      'imagenUrl': imagenUrl,
      'horario': horario,
      'diasDisponibles': diasDisponibles,
      'disponible': disponible,
    };
  }

  factory ServicioTuristico.fromMap(Map<String, dynamic> map) {
    return ServicioTuristico(
      id: map['id'] ?? '',
      nombre: map['nombre'] ?? '',
      descripcion: map['descripcion'] ?? '',
      ubicacion: map['ubicacion'] ?? '',
      precio: map['precio']?.toDouble() ?? 0.0,
      imagenUrl: map['imagenUrl'] ?? '',
      horario: map['horario'] ?? '',
      diasDisponibles: List<String>.from(map['diasDisponibles'] ?? []),
      disponible: map['disponible'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory ServicioTuristico.fromJson(String source) =>
      ServicioTuristico.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ServicioTuristico(id: $id, nombre: $nombre, descripcion: $descripcion, ubicacion: $ubicacion, precio: $precio, imagenUrl: $imagenUrl, horario: $horario, diasDisponibles: $diasDisponibles, disponible: $disponible)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ServicioTuristico &&
        other.id == id &&
        other.nombre == nombre &&
        other.descripcion == descripcion &&
        other.ubicacion == ubicacion &&
        other.precio == precio &&
        other.imagenUrl == imagenUrl &&
        other.horario == horario &&
        listEquals(other.diasDisponibles, diasDisponibles) &&
        other.disponible == disponible;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        nombre.hashCode ^
        descripcion.hashCode ^
        ubicacion.hashCode ^
        precio.hashCode ^
        imagenUrl.hashCode ^
        horario.hashCode ^
        diasDisponibles.hashCode ^
        disponible.hashCode;
  }
}
