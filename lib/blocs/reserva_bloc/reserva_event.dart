import '../../models/reserva.dart';
part of 'reserva_bloc.dart';

abstract class ReservaEvent extends Equatable {
  const ReservaEvent();

  @override
  List<Object> get props => [];
}

// Evento para cargar todas las reservas (o un conjunto según la lógica de negocio)
class LoadReservas extends ReservaEvent {}

// Evento para cargar una reserva específica por su ID
class LoadReservaById extends ReservaEvent {
  final String id;

  const LoadReservaById(this.id);

  @override
  List<Object> get props => [id];
}

// Evento para agregar una nueva reserva
class AddReserva extends ReservaEvent {
  final Reserva reserva;

  const AddReserva(this.reserva);

  @override
  List<Object> get props => [reserva];
}

// Evento para actualizar una reserva existente
class UpdateReserva extends ReservaEvent {
  final Reserva reserva;

  const UpdateReserva(this.reserva);

  @override
  List<Object> get props => [reserva];
}

// Evento para eliminar una reserva
// (Considera si las reservas se eliminan o se marcan como canceladas/archivadas)
class DeleteReserva extends ReservaEvent {
  final String id;

  const DeleteReserva(this.id);

  @override
  List<Object> get props => [id];
}
