part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final String token;
  final String name;
  final String role;

  const AuthAuthenticated({
    required this.token,
    required this.name,
    required this.role,
  });

  @override
  List<Object?> get props => [token, name, role];
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthOtpRequired extends AuthState {
  final String email;
  final String name;
  final String role;
  final String message;

  const AuthOtpRequired({
    required this.email,
    required this.name,
    required this.role,
    required this.message,
  });

  @override
  List<Object?> get props => [email, name, role, message];
}

class AuthOtpResent extends AuthState {
  final String message;

  const AuthOtpResent({required this.message});

  @override
  List<Object?> get props => [message];
}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}
