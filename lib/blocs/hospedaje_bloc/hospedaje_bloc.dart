import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/hospedaje.dart';
import '../../services/hospedaje_service.dart'; // Se creará después

part 'hospedaje_event.dart';
part 'hospedaje_state.dart';

class HospedajeBloc extends Bloc<HospedajeEvent, HospedajeState> {
  final HospedajeService _hospedajeService; // Se definirá después

  HospedajeBloc(this._hospedajeService) : super(HospedajeInitial()) {
    on<LoadHospedajes>(_onLoadHospedajes);
    on<LoadHospedajeById>(_onLoadHospedajeById);
    on<AddHospedaje>(_onAddHospedaje);
    on<UpdateHospedaje>(_onUpdateHospedaje);
    on<DeleteHospedaje>(_onDeleteHospedaje);
  }

  Future<void> _onLoadHospedajes(
    LoadHospedajes event,
    Emitter<HospedajeState> emit,
  ) async {
    emit(HospedajeLoading());
    try {
      final hospedajes = await _hospedajeService.getHospedajes();
      emit(HospedajesLoaded(hospedajes));
    } catch (e) {
      emit(HospedajeError(e.toString()));
    }
  }

  Future<void> _onLoadHospedajeById(
    LoadHospedajeById event,
    Emitter<HospedajeState> emit,
  ) async {
    emit(HospedajeLoading());
    try {
      final hospedaje = await _hospedajeService.getHospedajeById(event.id);
      // Service throws an exception if not found, caught by general catch.
      emit(HospedajeLoaded(hospedaje));
    } catch (e) {
      emit(HospedajeError(e.toString()));
    }
  }

  Future<void> _onAddHospedaje(
    AddHospedaje event,
    Emitter<HospedajeState> emit,
  ) async {
    emit(HospedajeLoading());
    try {
      await _hospedajeService.createHospedaje(event.hospedaje);
      emit(const HospedajeOperationSuccess(message: 'Hospedaje agregado con éxito'));
      add(LoadHospedajes()); // Recargar la lista
    } catch (e) {
      emit(HospedajeError(e.toString()));
    }
  }

  Future<void> _onUpdateHospedaje(
    UpdateHospedaje event,
    Emitter<HospedajeState> emit,
  ) async {
    emit(HospedajeLoading());
    try {
      await _hospedajeService.updateHospedaje(event.hospedaje.id, event.hospedaje);
      emit(const HospedajeOperationSuccess(message: 'Hospedaje actualizado con éxito'));
      add(LoadHospedajes()); // Recargar la lista
    } catch (e) {
      emit(HospedajeError(e.toString()));
    }
  }

  Future<void> _onDeleteHospedaje(
    DeleteHospedaje event,
    Emitter<HospedajeState> emit,
  ) async {
    emit(HospedajeLoading());
    try {
      await _hospedajeService.deleteHospedaje(event.id);
      emit(const HospedajeOperationSuccess(message: 'Hospedaje eliminado con éxito'));
      add(LoadHospedajes()); // Recargar la lista
    } catch (e) {
      emit(HospedajeError(e.toString()));
    }
  }
}
