import 'package:equatable/equatable.dart';

/// Base class for all failures
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Server/API related failures
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Network/Connection failures
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// Authentication failures
class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

/// Cache/Local storage failures
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// Validation failures
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}
