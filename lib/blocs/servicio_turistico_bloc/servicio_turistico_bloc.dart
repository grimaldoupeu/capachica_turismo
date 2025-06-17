import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/servicio_turistico.dart';
import '../../services/servicio_turistico_service.dart'; // Se creará después

part 'servicio_turistico_event.dart';
part 'servicio_turistico_state.dart';

class ServicioTuristicoBloc extends Bloc<ServicioTuristicoEvent, ServicioTuristicoState> {
  final ServicioTuristicoService _servicioTuristicoService; // Se definirá después

  ServicioTuristicoBloc(this._servicioTuristicoService) : super(ServicioTuristicoInitial()) {
    on<LoadServiciosTuristicos>(_onLoadServiciosTuristicos);
    on<LoadServicioTuristicoById>(_onLoadServicioTuristicoById);
    on<AddServicioTuristico>(_onAddServicioTuristico);
    on<UpdateServicioTuristico>(_onUpdateServicioTuristico);
    on<DeleteServicioTuristico>(_onDeleteServicioTuristico);
  }

  Future<void> _onLoadServiciosTuristicos(
    LoadServiciosTuristicos event,
    Emitter<ServicioTuristicoState> emit,
  ) async {
    emit(ServicioTuristicoLoading());
    try {
      final servicios = await _servicioTuristicoService.getServiciosTuristicos();
      emit(ServiciosTuristicosLoaded(servicios));
    } catch (e) {
      emit(ServicioTuristicoError(e.toString()));
    }
  }

  Future<void> _onLoadServicioTuristicoById(
    LoadServicioTuristicoById event,
    Emitter<ServicioTuristicoState> emit,
  ) async {
    emit(ServicioTuristicoLoading());
    try {
      final servicio = await _servicioTuristicoService.getServicioTuristicoById(event.id);
      // The service throws an exception if not found, which is caught below.
      // If it could return null, we'd need:
      // if (servicio != null) {
      emit(ServicioTuristicoLoaded(servicio));
      // } else {
      //   emit(const ServicioTuristicoError('Servicio no encontrado'));
      // }
    } catch (e) {
      emit(ServicioTuristicoError(e.toString()));
    }
  }

  Future<void> _onAddServicioTuristico(
    AddServicioTuristico event,
    Emitter<ServicioTuristicoState> emit,
  ) async {
    emit(ServicioTuristicoLoading());
    try {
      await _servicioTuristicoService.createServicioTuristico(event.servicio);
      emit(const ServicioTuristicoOperationSuccess(message: 'Servicio agregado con éxito'));
      add(LoadServiciosTuristicos()); // Recargar la lista
    } catch (e) {
      emit(ServicioTuristicoError(e.toString()));
    }
  }

  Future<void> _onUpdateServicioTuristico(
    UpdateServicioTuristico event,
    Emitter<ServicioTuristicoState> emit,
  ) async {
    emit(ServicioTuristicoLoading());
    try {
      await _servicioTuristicoService.updateServicioTuristico(event.servicio.id, event.servicio);
      emit(const ServicioTuristicoOperationSuccess(message: 'Servicio actualizado con éxito'));
      add(LoadServiciosTuristicos()); // Recargar la lista
    } catch (e) {
      emit(ServicioTuristicoError(e.toString()));
    }
  }

  Future<void> _onDeleteServicioTuristico(
    DeleteServicioTuristico event,
    Emitter<ServicioTuristicoState> emit,
  ) async {
    emit(ServicioTuristicoLoading());
    try {
      await _servicioTuristicoService.deleteServicioTuristico(event.id);
      emit(const ServicioTuristicoOperationSuccess(message: 'Servicio eliminado con éxito'));
      add(LoadServiciosTuristicos()); // Recargar la lista
    } catch (e) {
      emit(ServicioTuristicoError(e.toString()));
    }
  }
}
