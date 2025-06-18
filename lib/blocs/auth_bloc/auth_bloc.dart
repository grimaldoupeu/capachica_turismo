import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/user.dart';
import '../../services/auth_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;

  AuthBloc(this._authService) : super(AuthInitial()) {
    on<AuthAppStarted>(_onAuthAppStarted);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
  }

  Future<void> _onAuthAppStarted(
    AuthAppStarted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading()); // Opcional, podrías ir directo a verificar
    try {
      final user = await _authService.getCurrentUser();
      if (user != null) {
        emit(Authenticated(user: user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      // Esto podría pasar si hay un problema con secure_storage o una lógica inesperada en getCurrentUser
      print('Error en AuthAppStarted: $e');
      emit(Unauthenticated());
    }
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _authService.login(event.username, event.password);
      emit(Authenticated(user: user));
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    // No es necesario emitir AuthLoading aquí usualmente, el logout debería ser rápido
    // emit(AuthLoading());
    try {
      await _authService.logout();
      emit(Unauthenticated());
    } catch (e) {
      // Si el logout falla por alguna razón (ej. error al llamar a API de logout),
      // podrías emitir un estado de error específico o simplemente forzar Unauthenticated.
      // Por simplicidad, incluso si hay un error en el servicio de logout (ej. API),
      // el cliente se comportará como si el usuario hubiera cerrado sesión.
      print('Error durante el proceso de logout (se procederá a Unauthenticated): $e');
      emit(Unauthenticated());
    }
  }
}
