import 'package:equatable/equatable.dart';

class AuthResponse extends Equatable {
  final String? token;
  final String name;
  final String role;
  final String message;

  const AuthResponse({
    this.token,
    required this.name,
    required this.role,
    required this.message,
  });

  bool get requiresOtpVerification => token == null;
  bool get isSuccess => token != null;

  @override
  List<Object?> get props => [token, name, role, message];
}
