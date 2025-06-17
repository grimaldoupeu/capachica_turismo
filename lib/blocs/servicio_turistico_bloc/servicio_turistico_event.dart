import '../../models/servicio_turistico.dart';
part of 'servicio_turistico_bloc.dart';

abstract class ServicioTuristicoEvent extends Equatable {
  const ServicioTuristicoEvent();

  @override
  List<Object> get props => [];
}

// Evento para cargar todos los servicios turísticos
class LoadServiciosTuristicos extends ServicioTuristicoEvent {}

// Evento para cargar un servicio turístico específico por su ID
class LoadServicioTuristicoById extends ServicioTuristicoEvent {
  final String id;

  const LoadServicioTuristicoById(this.id);

  @override
  List<Object> get props => [id];
}

// Evento para agregar un nuevo servicio turístico
class AddServicioTuristico extends ServicioTuristicoEvent {
  final ServicioTuristico servicio;

  const AddServicioTuristico(this.servicio);

  @override
  List<Object> get props => [servicio];
}

// Evento para actualizar un servicio turístico existente
class UpdateServicioTuristico extends ServicioTuristicoEvent {
  final ServicioTuristico servicio;

  const UpdateServicioTuristico(this.servicio);

  @override
  List<Object> get props => [servicio];
}

// Evento para eliminar un servicio turístico
class DeleteServicioTuristico extends ServicioTuristicoEvent {
  final String id;

  const DeleteServicioTuristico(this.id);

  @override
  List<Object> get props => [id];
}
