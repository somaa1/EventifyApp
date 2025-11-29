import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/registration.dart';
import '../repositories/registration_repository.dart';

class RegisterForEventUseCase {
  final RegistrationRepository repository;

  const RegisterForEventUseCase(this.repository);

  Future<Either<Failure, Registration>> call({
    required int eventId,
    int? invitationId,
  }) {
    return repository.registerForEvent(
      eventId: eventId,
      invitationId: invitationId,
    );
  }
}
