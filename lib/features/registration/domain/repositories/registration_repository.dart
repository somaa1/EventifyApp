import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/registration.dart';

/// Repository interface for registration-related operations
abstract class RegistrationRepository {
  /// Register for an event
  ///
  /// Returns [Right<Registration>] on success
  /// Returns [Left<Failure>] on error
  Future<Either<Failure, Registration>> registerForEvent({
    required int eventId,
    int? invitationId,
  });

  /// Get registration details by token
  ///
  /// Returns [Right<Registration>] on success
  /// Returns [Left<Failure>] on error
  Future<Either<Failure, Registration>> getRegistrationByToken(
      String token);

  /// Get registration by invitation token
  ///
  /// Returns [Right<Map>] containing eventId and invitationId on success
  /// Returns [Left<Failure>] on error
  Future<Either<Failure, Map<String, int>>> getRegistrationByInvitation(
      String token);
}
