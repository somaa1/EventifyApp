// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventModel _$EventModelFromJson(Map<String, dynamic> json) => EventModel(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  location: json['location'] as String,
  startDateTime: DateTime.parse(json['startDateTime'] as String),
  endDateTime: DateTime.parse(json['endDateTime'] as String),
  eventType: json['eventType'] as String,
  capacity: (json['capacity'] as num).toInt(),
  attendeeCount: (json['attendeeCount'] as num).toInt(),
  organizerName: json['organizerName'] as String,
  organizerId: json['organizerId'] as String,
  imageUrl: json['imageUrl'] as String?,
  isRegistered: json['isRegistered'] as bool? ?? false,
  status: json['status'] as String,
);

Map<String, dynamic> _$EventModelToJson(EventModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'location': instance.location,
      'startDateTime': instance.startDateTime.toIso8601String(),
      'endDateTime': instance.endDateTime.toIso8601String(),
      'eventType': instance.eventType,
      'capacity': instance.capacity,
      'attendeeCount': instance.attendeeCount,
      'organizerName': instance.organizerName,
      'organizerId': instance.organizerId,
      'imageUrl': instance.imageUrl,
      'isRegistered': instance.isRegistered,
      'status': instance.status,
    };
