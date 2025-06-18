import '../../models/user.dart';
part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

// Estado inicial, antes de que se haya determinado el estado de autenticación
class AuthInitial extends AuthState {}

// Estado mientras se realiza una operación de autenticación (ej. login)
class AuthLoading extends AuthState {}

// Estado cuando el usuario está autenticado
class Authenticated extends AuthState {
  final User user;
  // Opcionalmente, podrías incluir el token aquí si alguna parte de la UI lo necesitara directamente,
  // pero generalmente es mejor que el token sea manejado por el AuthService y usado por otros servicios.
  // final String token;

  const Authenticated({required this.user /*, required this.token */});

  @override
  List<Object?> get props => [user /*, token */];
}

// Estado cuando el usuario no está autenticado o ha cerrado sesión
class Unauthenticated extends AuthState {}

// Estado cuando ocurre un error durante el proceso de autenticación (ej. login fallido)
class AuthFailure extends AuthState {
  final String message;

  const AuthFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
