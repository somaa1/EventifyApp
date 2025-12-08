import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_stats.dart';
import '../../../profile/domain/entities/user_profile.dart';

/// Repository interface for user-related operations
abstract class UserRepository {
  /// Get current user's statistics
  ///
  /// Returns different stats based on user role:
  /// - ATTENDEE: registeredEvents, eventsAttended
  /// - ORGANIZER: eventsCreated, totalAttendees, upcomingEvents, pastEvents
  /// - ADMIN: all stats including totalUsers
  ///
  /// Returns [Right<UserStats>] on success
  /// Returns [Left<Failure>] on error
  Future<Either<Failure, UserStats>> getUserStats();

  /// Get current user's profile information
  Future<Either<Failure, UserProfile>> getCurrentUser();

  /// Update current user's profile information
  Future<Either<Failure, UserProfile>> updateProfile(
    Map<String, dynamic> data,
  );
}
