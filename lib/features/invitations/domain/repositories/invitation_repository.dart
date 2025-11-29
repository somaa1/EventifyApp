import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/invitation.dart';

/// Repository interface for invitation-related operations
abstract class InvitationRepository {
  /// Send invitation to an email for a private event
  ///
  /// Returns [Right<Invitation>] on success
  /// Returns [Left<Failure>] on error
  Future<Either<Failure, Invitation>> sendInvitation({
    required int eventId,
    required String email,
  });
}
