import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/reserva.dart';
import '../../services/reserva_service.dart'; // Se creará después

part 'reserva_event.dart';
part 'reserva_state.dart';

class ReservaBloc extends Bloc<ReservaEvent, ReservaState> {
  final ReservaService _reservaService; // Se definirá después

  ReservaBloc(this._reservaService) : super(ReservaInitial()) {
    on<LoadReservas>(_onLoadReservas);
    on<LoadReservaById>(_onLoadReservaById);
    on<AddReserva>(_onAddReserva);
    on<UpdateReserva>(_onUpdateReserva);
    on<DeleteReserva>(_onDeleteReserva);
  }

  Future<void> _onLoadReservas(
    LoadReservas event,
    Emitter<ReservaState> emit,
  ) async {
    emit(ReservaLoading());
    try {
      final reservas = await _reservaService.getReservas();
      emit(ReservasLoaded(reservas));
    } catch (e) {
      emit(ReservaError(e.toString()));
    }
  }

  Future<void> _onLoadReservaById(
    LoadReservaById event,
    Emitter<ReservaState> emit,
  ) async {
    emit(ReservaLoading());
    try {
      final reserva = await _reservaService.getReservaById(event.id);
      // Service throws an exception if not found, caught by general catch.
      emit(ReservaLoaded(reserva));
    } catch (e) {
      emit(ReservaError(e.toString()));
    }
  }

  Future<void> _onAddReserva(
    AddReserva event,
    Emitter<ReservaState> emit,
  ) async {
    emit(ReservaLoading());
    try {
      await _reservaService.createReserva(event.reserva);
      emit(const ReservaOperationSuccess(message: 'Reserva agregada con éxito'));
      add(LoadReservas());
    } catch (e) {
      emit(ReservaError(e.toString()));
    }
  }

  Future<void> _onUpdateReserva(
    UpdateReserva event,
    Emitter<ReservaState> emit,
  ) async {
    emit(ReservaLoading());
    try {
      await _reservaService.updateReserva(event.reserva.id, event.reserva);
      emit(const ReservaOperationSuccess(message: 'Reserva actualizada con éxito'));
      add(LoadReservas());
    } catch (e) {
      emit(ReservaError(e.toString()));
    }
  }

  Future<void> _onDeleteReserva(
    DeleteReserva event,
    Emitter<ReservaState> emit,
  ) async {
    emit(ReservaLoading());
    try {
      await _reservaService.deleteReserva(event.id);
      emit(const ReservaOperationSuccess(message: 'Reserva eliminada con éxito'));
      add(LoadReservas());
    } catch (e) {
      emit(ReservaError(e.toString()));
    }
  }
}
