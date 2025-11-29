import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/event.dart';
import '../repositories/event_repository.dart';

/// Use case for fetching a single event by ID
class GetEventDetailsUseCase {
  final EventRepository _repository;

  GetEventDetailsUseCase(this._repository);

  /// Execute the use case to get event details
  ///
  /// [eventId] - The ID of the event to fetch
  ///
  /// Returns [Right<Event>] on success
  /// Returns [Left<Failure>] on error
  Future<Either<Failure, Event>> call(String eventId) async {
    return await _repository.getEventById(eventId);
  }
}
