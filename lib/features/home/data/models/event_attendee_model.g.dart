// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_attendee_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventAttendeeModel _$EventAttendeeModelFromJson(Map<String, dynamic> json) =>
    EventAttendeeModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      email: json['email'] as String,
      registeredAt: DateTime.parse(json['registeredAt'] as String),
      attended: json['attended'] as bool,
    );

Map<String, dynamic> _$EventAttendeeModelToJson(EventAttendeeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'registeredAt': instance.registeredAt.toIso8601String(),
      'attended': instance.attended,
    };
