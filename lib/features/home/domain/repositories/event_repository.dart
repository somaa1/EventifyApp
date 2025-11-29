import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/event.dart';
import '../entities/event_filter.dart';

/// Repository interface for event-related operations
abstract class EventRepository {
  /// Get list of all events with optional filters
  ///
  /// Returns [Right<List<Event>>] on success
  /// Returns [Left<Failure>] on error
  Future<Either<Failure, List<Event>>> getEvents({
    EventFilter? filter,
    int? page,
    int? limit,
  });

  /// Get a single event by ID
  ///
  /// Returns [Right<Event>] on success
  /// Returns [Left<Failure>] on error
  Future<Either<Failure, Event>> getEventById(String eventId);

  /// Get events created by the current user (for ORGANIZER/ADMIN)
  ///
  /// Returns [Right<List<Event>>] on success
  /// Returns [Left<Failure>] on error
  Future<Either<Failure, List<Event>>> getMyEvents();

  /// Get events the current user is registered for (for ATTENDEE)
  ///
  /// Returns [Right<List<Event>>] on success
  /// Returns [Left<Failure>] on error
  Future<Either<Failure, List<Event>>> getRegisteredEvents();

  /// Search events by query string
  ///
  /// Returns [Right<List<Event>>] on success
  /// Returns [Left<Failure>] on error
  Future<Either<Failure, List<Event>>> searchEvents(String query);
}
