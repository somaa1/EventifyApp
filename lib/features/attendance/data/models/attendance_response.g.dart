// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttendanceResponse _$AttendanceResponseFromJson(Map<String, dynamic> json) =>
    AttendanceResponse(
      id: (json['id'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      eventId: (json['eventId'] as num).toInt(),
      registrationId: (json['registrationId'] as num).toInt(),
      confirmedAt: DateTime.parse(json['confirmedAt'] as String),
    );

Map<String, dynamic> _$AttendanceResponseToJson(AttendanceResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'eventId': instance.eventId,
      'registrationId': instance.registrationId,
      'confirmedAt': instance.confirmedAt.toIso8601String(),
    };
