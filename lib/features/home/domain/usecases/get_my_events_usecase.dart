import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/event.dart';
import '../repositories/event_repository.dart';

class GetMyEventsUseCase {
  final EventRepository repository;
  const GetMyEventsUseCase(this.repository);

  Future<Either<Failure, List<Event>>> call() {
    return repository.getMyEvents();
  }
}
