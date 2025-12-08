import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/event.dart';
import '../repositories/event_repository.dart';

class UpdateEventUseCase {
  final EventRepository repository;
  const UpdateEventUseCase(this.repository);

  Future<Either<Failure, Event>> call(
    String id,
    Map<String, dynamic> data,
  ) {
    return repository.updateEvent(id, data);
  }
}
