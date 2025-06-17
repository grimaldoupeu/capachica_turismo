import '../../models/hospedaje.dart';
part of 'hospedaje_bloc.dart';

abstract class HospedajeEvent extends Equatable {
  const HospedajeEvent();

  @override
  List<Object> get props => [];
}

// Evento para cargar todos los hospedajes
class LoadHospedajes extends HospedajeEvent {}

// Evento para cargar un hospedaje específico por su ID
class LoadHospedajeById extends HospedajeEvent {
  final String id;

  const LoadHospedajeById(this.id);

  @override
  List<Object> get props => [id];
}

// Evento para agregar un nuevo hospedaje
class AddHospedaje extends HospedajeEvent {
  final Hospedaje hospedaje;

  const AddHospedaje(this.hospedaje);

  @override
  List<Object> get props => [hospedaje];
}

// Evento para actualizar un hospedaje existente
class UpdateHospedaje extends HospedajeEvent {
  final Hospedaje hospedaje;

  const UpdateHospedaje(this.hospedaje);

  @override
  List<Object> get props => [hospedaje];
}

// Evento para eliminar un hospedaje
class DeleteHospedaje extends HospedajeEvent {
  final String id;

  const DeleteHospedaje(this.id);

  @override
  List<Object> get props => [id];
}
