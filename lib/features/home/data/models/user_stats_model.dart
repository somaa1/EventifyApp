import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user_stats.dart';

part 'user_stats_model.g.dart';

/// Data model for UserStats with JSON serialization
@JsonSerializable()
class UserStatsModel extends UserStats {
  const UserStatsModel({
    super.eventsCreated,
    super.totalAttendees,
    super.upcomingEvents,
    super.pastEvents,
    super.totalUsers,
    super.registeredEvents,
    super.eventsAttended,
  });

  /// Create UserStatsModel from JSON
  factory UserStatsModel.fromJson(Map<String, dynamic> json) =>
      _$UserStatsModelFromJson(json);

  /// Convert UserStatsModel to JSON
  Map<String, dynamic> toJson() => _$UserStatsModelToJson(this);

  /// Create UserStatsModel from UserStats entity
  factory UserStatsModel.fromEntity(UserStats stats) {
    return UserStatsModel(
      eventsCreated: stats.eventsCreated,
      totalAttendees: stats.totalAttendees,
      upcomingEvents: stats.upcomingEvents,
      pastEvents: stats.pastEvents,
      totalUsers: stats.totalUsers,
      registeredEvents: stats.registeredEvents,
      eventsAttended: stats.eventsAttended,
    );
  }

  /// Convert to UserStats entity
  UserStats toEntity() {
    return UserStats(
      eventsCreated: eventsCreated,
      totalAttendees: totalAttendees,
      upcomingEvents: upcomingEvents,
      pastEvents: pastEvents,
      totalUsers: totalUsers,
      registeredEvents: registeredEvents,
      eventsAttended: eventsAttended,
    );
  }

  /// Empty stats model
  static const empty = UserStatsModel();
}
