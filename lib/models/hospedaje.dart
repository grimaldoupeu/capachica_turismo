import 'dart:convert';
import 'package:flutter/foundation.dart';

class Hospedaje {
  final String id;
  final String nombre;
  final String descripcion;
  final String ubicacion; // Asumo que es una dirección o descripción de la ubicación
  final double precio; // Asumo que es precioPorNoche o similar
  final List<String> imagenes;
  final List<String> servicios; // Lista de servicios ofrecidos
  final int capacidadMaxima;
  final double calificacion; // Ej: 4.5
  final int numeroReviews;
  final String tipoAlojamiento; // hotel, hostal, casa, etc.
  final Map<String, dynamic> coordenadas; // Ej: {'lat': -15.0, 'lng': -70.0}
  final bool disponible;

  Hospedaje({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.ubicacion,
    required this.precio,
    required this.imagenes,
    required this.servicios,
    required this.capacidadMaxima,
    required this.calificacion,
    required this.numeroReviews,
    required this.tipoAlojamiento,
    required this.coordenadas,
    required this.disponible,
  });

  Hospedaje copyWith({
    String? id,
    String? nombre,
    String? descripcion,
    String? ubicacion,
    double? precio,
    List<String>? imagenes,
    List<String>? servicios,
    int? capacidadMaxima,
    double? calificacion,
    int? numeroReviews,
    String? tipoAlojamiento,
    Map<String, dynamic>? coordenadas,
    bool? disponible,
  }) {
    return Hospedaje(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      ubicacion: ubicacion ?? this.ubicacion,
      precio: precio ?? this.precio,
      imagenes: imagenes ?? this.imagenes,
      servicios: servicios ?? this.servicios,
      capacidadMaxima: capacidadMaxima ?? this.capacidadMaxima,
      calificacion: calificacion ?? this.calificacion,
      numeroReviews: numeroReviews ?? this.numeroReviews,
      tipoAlojamiento: tipoAlojamiento ?? this.tipoAlojamiento,
      coordenadas: coordenadas ?? this.coordenadas,
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
      'imagenes': imagenes,
      'servicios': servicios,
      'capacidadMaxima': capacidadMaxima,
      'calificacion': calificacion,
      'numeroReviews': numeroReviews,
      'tipoAlojamiento': tipoAlojamiento,
      'coordenadas': coordenadas,
      'disponible': disponible,
    };
  }

  factory Hospedaje.fromMap(Map<String, dynamic> map) {
    return Hospedaje(
      id: map['id'] ?? '',
      nombre: map['nombre'] ?? '',
      descripcion: map['descripcion'] ?? '',
      ubicacion: map['ubicacion'] ?? '',
      precio: map['precio']?.toDouble() ?? 0.0,
      imagenes: List<String>.from(map['imagenes'] ?? []),
      servicios: List<String>.from(map['servicios'] ?? []),
      capacidadMaxima: map['capacidadMaxima']?.toInt() ?? 0,
      calificacion: map['calificacion']?.toDouble() ?? 0.0,
      numeroReviews: map['numeroReviews']?.toInt() ?? 0,
      tipoAlojamiento: map['tipoAlojamiento'] ?? '',
      coordenadas: Map<String, dynamic>.from(map['coordenadas'] ?? {}),
      disponible: map['disponible'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Hospedaje.fromJson(String source) =>
      Hospedaje.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Hospedaje(id: $id, nombre: $nombre, descripcion: $descripcion, ubicacion: $ubicacion, precio: $precio, imagenes: $imagenes, servicios: $servicios, capacidadMaxima: $capacidadMaxima, calificacion: $calificacion, numeroReviews: $numeroReviews, tipoAlojamiento: $tipoAlojamiento, coordenadas: $coordenadas, disponible: $disponible)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Hospedaje &&
        other.id == id &&
        other.nombre == nombre &&
        other.descripcion == descripcion &&
        other.ubicacion == ubicacion &&
        other.precio == precio &&
        listEquals(other.imagenes, imagenes) &&
        listEquals(other.servicios, servicios) &&
        other.capacidadMaxima == capacidadMaxima &&
        other.calificacion == calificacion &&
        other.numeroReviews == numeroReviews &&
        other.tipoAlojamiento == tipoAlojamiento &&
        mapEquals(other.coordenadas, coordenadas) &&
        other.disponible == disponible;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        nombre.hashCode ^
        descripcion.hashCode ^
        ubicacion.hashCode ^
        precio.hashCode ^
        imagenes.hashCode ^
        servicios.hashCode ^
        capacidadMaxima.hashCode ^
        calificacion.hashCode ^
        numeroReviews.hashCode ^
        tipoAlojamiento.hashCode ^
        coordenadas.hashCode ^
        disponible.hashCode;
  }
}
