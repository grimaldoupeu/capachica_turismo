import '../../models/servicio_turistico.dart';
part of 'servicio_turistico_bloc.dart';

abstract class ServicioTuristicoState extends Equatable {
  const ServicioTuristicoState();

  @override
  List<Object?> get props => [];
}

// Estado inicial
class ServicioTuristicoInitial extends ServicioTuristicoState {}

// Estado de carga
class ServicioTuristicoLoading extends ServicioTuristicoState {}

// Estado cuando la lista de servicios turísticos se ha cargado
class ServiciosTuristicosLoaded extends ServicioTuristicoState {
  final List<ServicioTuristico> servicios;

  const ServiciosTuristicosLoaded(this.servicios);

  @override
  List<Object?> get props => [servicios];
}

// Estado cuando un solo servicio turístico se ha cargado
class ServicioTuristicoLoaded extends ServicioTuristicoState {
  final ServicioTuristico servicio;

  const ServicioTuristicoLoaded(this.servicio);

  @override
  List<Object?> get props => [servicio];
}

// Estado para operaciones CUD exitosas (Crear, Actualizar, Eliminar)
class ServicioTuristicoOperationSuccess extends ServicioTuristicoState {
  final String? message; // Mensaje opcional de éxito

  const ServicioTuristicoOperationSuccess({this.message});

  @override
  List<Object?> get props => [message];
}

// Estado de error
class ServicioTuristicoError extends ServicioTuristicoState {
  final String message;

  const ServicioTuristicoError(this.message);

  @override
  List<Object?> get props => [message];
}
