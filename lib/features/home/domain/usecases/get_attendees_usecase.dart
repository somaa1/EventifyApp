import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/attendee.dart';
import '../repositories/event_repository.dart';

class GetAttendeesUseCase {
  final EventRepository repository;
  const GetAttendeesUseCase(this.repository);

  Future<Either<Failure, List<Attendee>>> call(String eventId) {
    return repository.getAttendees(eventId);
  }
}
