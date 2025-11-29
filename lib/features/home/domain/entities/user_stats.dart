import 'package:equatable/equatable.dart';

/// User statistics entity for displaying dashboard metrics
class UserStats extends Equatable {
  /// Total number of events created (for ORGANIZER/ADMIN)
  final int eventsCreated;

  /// Total number of attendees across all events (for ORGANIZER/ADMIN)
  final int totalAttendees;

  /// Number of upcoming events
  final int upcomingEvents;

  /// Number of past events
  final int pastEvents;

  /// Total number of users in the system (for ADMIN only)
  final int? totalUsers;

  /// Total number of registered events (for ATTENDEE)
  final int registeredEvents;

  /// Number of events attended (for ATTENDEE)
  final int eventsAttended;

  const UserStats({
    this.eventsCreated = 0,
    this.totalAttendees = 0,
    this.upcomingEvents = 0,
    this.pastEvents = 0,
    this.totalUsers,
    this.registeredEvents = 0,
    this.eventsAttended = 0,
  });

  /// Empty stats for initial state
  static const empty = UserStats();

  @override
  List<Object?> get props => [
        eventsCreated,
        totalAttendees,
        upcomingEvents,
        pastEvents,
        totalUsers,
        registeredEvents,
        eventsAttended,
      ];
}
