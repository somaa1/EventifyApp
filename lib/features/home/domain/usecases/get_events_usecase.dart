import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/event.dart';
import '../entities/event_filter.dart';
import '../repositories/event_repository.dart';

/// Use case for fetching events with optional filters
class GetEventsUseCase {
  final EventRepository _repository;

  GetEventsUseCase(this._repository);

  /// Execute the use case to get events
  ///
  /// [filter] - Optional filter criteria for events
  /// [page] - Page number for pagination
  /// [limit] - Number of items per page
  ///
  /// Returns [Right<List<Event>>] on success
  /// Returns [Left<Failure>] on error
  Future<Either<Failure, List<Event>>> call({
    EventFilter? filter,
    int? page,
    int? limit,
  }) async {
    return await _repository.getEvents(
      filter: filter,
      page: page,
      limit: limit,
    );
  }
}
