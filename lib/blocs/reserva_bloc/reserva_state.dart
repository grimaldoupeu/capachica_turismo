import '../../models/reserva.dart';
part of 'reserva_bloc.dart';

abstract class ReservaState extends Equatable {
  const ReservaState();

  @override
  List<Object?> get props => [];
}

// Estado inicial
class ReservaInitial extends ReservaState {}

// Estado de carga
class ReservaLoading extends ReservaState {}

// Estado cuando la lista de reservas se ha cargado
class ReservasLoaded extends ReservaState {
  final List<Reserva> reservas;

  const ReservasLoaded(this.reservas);

  @override
  List<Object?> get props => [reservas];
}

// Estado cuando una sola reserva se ha cargado
class ReservaLoaded extends ReservaState {
  final Reserva reserva;

  const ReservaLoaded(this.reserva);

  @override
  List<Object?> get props => [reserva];
}

// Estado para operaciones CUD exitosas
class ReservaOperationSuccess extends ReservaState {
  final String? message;

  const ReservaOperationSuccess({this.message});

  @override
  List<Object?> get props => [message];
}

// Estado de error
class ReservaError extends ReservaState {
  final String message;

  const ReservaError(this.message);

  @override
  List<Object?> get props => [message];
}
