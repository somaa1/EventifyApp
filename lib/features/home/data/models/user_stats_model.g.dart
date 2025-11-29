// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserStatsModel _$UserStatsModelFromJson(Map<String, dynamic> json) =>
    UserStatsModel(
      eventsCreated: (json['eventsCreated'] as num?)?.toInt() ?? 0,
      totalAttendees: (json['totalAttendees'] as num?)?.toInt() ?? 0,
      upcomingEvents: (json['upcomingEvents'] as num?)?.toInt() ?? 0,
      pastEvents: (json['pastEvents'] as num?)?.toInt() ?? 0,
      totalUsers: (json['totalUsers'] as num?)?.toInt(),
      registeredEvents: (json['registeredEvents'] as num?)?.toInt() ?? 0,
      eventsAttended: (json['eventsAttended'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$UserStatsModelToJson(UserStatsModel instance) =>
    <String, dynamic>{
      'eventsCreated': instance.eventsCreated,
      'totalAttendees': instance.totalAttendees,
      'upcomingEvents': instance.upcomingEvents,
      'pastEvents': instance.pastEvents,
      'totalUsers': instance.totalUsers,
      'registeredEvents': instance.registeredEvents,
      'eventsAttended': instance.eventsAttended,
    };
