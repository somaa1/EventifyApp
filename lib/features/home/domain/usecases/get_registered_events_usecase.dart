import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/event.dart';
import '../repositories/event_repository.dart';

/// Use case for fetching events the user is registered for
class GetRegisteredEventsUseCase {
  final EventRepository _repository;

  GetRegisteredEventsUseCase(this._repository);

  /// Execute the use case to get registered events
  ///
  /// Returns [Right<List<Event>>] on success
  /// Returns [Left<Failure>] on error
  Future<Either<Failure, List<Event>>> call() async {
    return await _repository.getRegisteredEvents();
  }
}
