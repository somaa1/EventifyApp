import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_stats.dart';
import '../repositories/user_repository.dart';

/// Use case for fetching current user's statistics
class GetUserStatsUseCase {
  final UserRepository _repository;

  GetUserStatsUseCase(this._repository);

  /// Execute the use case to get user statistics
  ///
  /// Returns role-specific stats:
  /// - ATTENDEE: registeredEvents, eventsAttended
  /// - ORGANIZER: eventsCreated, totalAttendees, upcomingEvents, pastEvents
  /// - ADMIN: all stats including totalUsers
  ///
  /// Returns [Right<UserStats>] on success
  /// Returns [Left<Failure>] on error
  Future<Either<Failure, UserStats>> call() async {
    return await _repository.getUserStats();
  }
}
