import '../../models/hospedaje.dart';
part of 'hospedaje_bloc.dart';

abstract class HospedajeState extends Equatable {
  const HospedajeState();

  @override
  List<Object?> get props => [];
}

// Estado inicial
class HospedajeInitial extends HospedajeState {}

// Estado de carga
class HospedajeLoading extends HospedajeState {}

// Estado cuando la lista de hospedajes se ha cargado
class HospedajesLoaded extends HospedajeState {
  final List<Hospedaje> hospedajes;

  const HospedajesLoaded(this.hospedajes);

  @override
  List<Object?> get props => [hospedajes];
}

// Estado cuando un solo hospedaje se ha cargado
class HospedajeLoaded extends HospedajeState {
  final Hospedaje hospedaje;

  const HospedajeLoaded(this.hospedaje);

  @override
  List<Object?> get props => [hospedaje];
}

// Estado para operaciones CUD exitosas (Crear, Actualizar, Eliminar)
class HospedajeOperationSuccess extends HospedajeState {
  final String? message; // Mensaje opcional de éxito

  const HospedajeOperationSuccess({this.message});

  @override
  List<Object?> get props => [message];
}

// Estado de error
class HospedajeError extends HospedajeState {
  final String message;

  const HospedajeError(this.message);

  @override
  List<Object?> get props => [message];
}
