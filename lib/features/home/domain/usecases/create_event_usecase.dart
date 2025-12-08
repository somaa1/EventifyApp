import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/event.dart';
import '../repositories/event_repository.dart';

class CreateEventUseCase {
  final EventRepository repository;
  const CreateEventUseCase(this.repository);

  Future<Either<Failure, Event>> call(Map<String, dynamic> data) {
    return repository.createEvent(data);
  }
}
