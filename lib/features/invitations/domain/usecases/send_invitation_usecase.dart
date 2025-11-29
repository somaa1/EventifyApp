import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/invitation.dart';
import '../repositories/invitation_repository.dart';

class SendInvitationUseCase {
  final InvitationRepository repository;

  const SendInvitationUseCase(this.repository);

  Future<Either<Failure, Invitation>> call({
    required int eventId,
    required String email,
  }) {
    return repository.sendInvitation(
      eventId: eventId,
      email: email,
    );
  }
}
