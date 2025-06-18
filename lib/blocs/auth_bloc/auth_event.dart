part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

// Evento disparado al iniciar la aplicación para verificar el estado de autenticación
class AuthAppStarted extends AuthEvent {}

// Evento disparado cuando el usuario intenta iniciar sesión
class AuthLoginRequested extends AuthEvent {
  final String username;
  final String password;

  const AuthLoginRequested({required this.username, required this.password});

  @override
  List<Object> get props => [username, password];
}

// Evento disparado cuando el usuario solicita cerrar sesión
class AuthLogoutRequested extends AuthEvent {}
