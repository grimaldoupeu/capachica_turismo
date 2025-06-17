import 'dart:convert';
import 'package:flutter/foundation.dart';

class Reserva {
  final String id;
  final String hospedajeId; // ID del hospedaje reservado
  final String usuarioId;   // ID del usuario que hace la reserva
  final String nombreHospedaje; // Nombre del hospedaje, puede ser útil para mostrar en la UI
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final int numeroHuespedes;
  final double precioTotal;
  final String estado; // Ej: "Pendiente", "Confirmada", "Cancelada"
  final DateTime fechaReserva; // Cuándo se creó la reserva
  final Map<String, String> datosContacto; // Ej: {'email': '...', 'telefono': '...'}
  final String? notasEspeciales;

  Reserva({
    required this.id,
    required this.hospedajeId,
    required this.usuarioId,
    required this.nombreHospedaje,
    required this.fechaInicio,
    required this.fechaFin,
    required this.numeroHuespedes,
    required this.precioTotal,
    required this.estado,
    required this.fechaReserva,
    required this.datosContacto,
    this.notasEspeciales,
  });

  Reserva copyWith({
    String? id,
    String? hospedajeId,
    String? usuarioId,
    String? nombreHospedaje,
    DateTime? fechaInicio,
    DateTime? fechaFin,
    int? numeroHuespedes,
    double? precioTotal,
    String? estado,
    DateTime? fechaReserva,
    Map<String, String>? datosContacto,
    String? notasEspeciales,
  }) {
    return Reserva(
      id: id ?? this.id,
      hospedajeId: hospedajeId ?? this.hospedajeId,
      usuarioId: usuarioId ?? this.usuarioId,
      nombreHospedaje: nombreHospedaje ?? this.nombreHospedaje,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      fechaFin: fechaFin ?? this.fechaFin,
      numeroHuespedes: numeroHuespedes ?? this.numeroHuespedes,
      precioTotal: precioTotal ?? this.precioTotal,
      estado: estado ?? this.estado,
      fechaReserva: fechaReserva ?? this.fechaReserva,
      datosContacto: datosContacto ?? this.datosContacto,
      notasEspeciales: notasEspeciales ?? this.notasEspeciales,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'hospedajeId': hospedajeId,
      'usuarioId': usuarioId,
      'nombreHospedaje': nombreHospedaje,
      'fechaInicio': fechaInicio.toIso8601String(), // Convertir DateTime a String
      'fechaFin': fechaFin.toIso8601String(),       // Convertir DateTime a String
      'numeroHuespedes': numeroHuespedes,
      'precioTotal': precioTotal,
      'estado': estado,
      'fechaReserva': fechaReserva.toIso8601String(), // Convertir DateTime a String
      'datosContacto': datosContacto,
      'notasEspeciales': notasEspeciales,
    };
  }

  factory Reserva.fromMap(Map<String, dynamic> map) {
    return Reserva(
      id: map['id'] ?? '',
      hospedajeId: map['hospedajeId'] ?? '',
      usuarioId: map['usuarioId'] ?? '',
      nombreHospedaje: map['nombreHospedaje'] ?? '',
      fechaInicio: DateTime.parse(map['fechaInicio'] ?? DateTime.now().toIso8601String()), // Parsear String a DateTime
      fechaFin: DateTime.parse(map['fechaFin'] ?? DateTime.now().toIso8601String()),       // Parsear String a DateTime
      numeroHuespedes: map['numeroHuespedes']?.toInt() ?? 0,
      precioTotal: map['precioTotal']?.toDouble() ?? 0.0,
      estado: map['estado'] ?? '',
      fechaReserva: DateTime.parse(map['fechaReserva'] ?? DateTime.now().toIso8601String()), // Parsear String a DateTime
      datosContacto: Map<String, String>.from(map['datosContacto'] ?? {}),
      notasEspeciales: map['notasEspeciales'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Reserva.fromJson(String source) =>
      Reserva.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Reserva(id: $id, hospedajeId: $hospedajeId, usuarioId: $usuarioId, nombreHospedaje: $nombreHospedaje, fechaInicio: $fechaInicio, fechaFin: $fechaFin, numeroHuespedes: $numeroHuespedes, precioTotal: $precioTotal, estado: $estado, fechaReserva: $fechaReserva, datosContacto: $datosContacto, notasEspeciales: $notasEspeciales)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Reserva &&
        other.id == id &&
        other.hospedajeId == hospedajeId &&
        other.usuarioId == usuarioId &&
        other.nombreHospedaje == nombreHospedaje &&
        other.fechaInicio == fechaInicio &&
        other.fechaFin == fechaFin &&
        other.numeroHuespedes == numeroHuespedes &&
        other.precioTotal == precioTotal &&
        other.estado == estado &&
        other.fechaReserva == fechaReserva &&
        mapEquals(other.datosContacto, datosContacto) &&
        other.notasEspeciales == notasEspeciales;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        hospedajeId.hashCode ^
        usuarioId.hashCode ^
        nombreHospedaje.hashCode ^
        fechaInicio.hashCode ^
        fechaFin.hashCode ^
        numeroHuespedes.hashCode ^
        precioTotal.hashCode ^
        estado.hashCode ^
        fechaReserva.hashCode ^
        datosContacto.hashCode ^
        notasEspeciales.hashCode;
  }
}
