import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/event.dart';

part 'event_model.g.dart';

/// Data model for Event with JSON serialization
@JsonSerializable()
class EventModel extends Event {
  const EventModel({
    required super.id,
    required super.title,
    required super.description,
    required super.location,
    required super.startDateTime,
    required super.endDateTime,
    required super.eventType,
    required super.capacity,
    required super.attendeeCount,
    required super.organizerName,
    required super.organizerId,
    super.imageUrl,
    super.isRegistered,
    required super.status,
  });

  /// Create EventModel from JSON with default values for missing fields
  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id']?.toString() ?? '0',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      location: json['location'] as String? ?? '',
      startDateTime: json['startDateTime'] != null
          ? DateTime.parse(json['startDateTime'] as String)
          : DateTime.now(),
      endDateTime: json['endDateTime'] != null
          ? DateTime.parse(json['endDateTime'] as String)
          : DateTime.now(),
      eventType: json['eventType'] as String? ?? 'PUBLIC',
      // Backend doesn't return these fields - use defaults
      capacity: json['capacity'] as int? ?? 0,
      attendeeCount: json['attendeeCount'] as int? ?? 0,
      organizerName: json['organizerName'] as String? ?? '',
      organizerId: json['organizerId']?.toString() ?? '',
      imageUrl: json['imageUrl'] as String?,
      isRegistered: json['isRegistered'] as bool? ?? false,
      status: json['status'] as String? ?? 'UPCOMING',
    );
  }

  /// Convert EventModel to JSON
  Map<String, dynamic> toJson() => _$EventModelToJson(this);

  /// Create EventModel from Event entity
  factory EventModel.fromEntity(Event event) {
    return EventModel(
      id: event.id,
      title: event.title,
      description: event.description,
      location: event.location,
      startDateTime: event.startDateTime,
      endDateTime: event.endDateTime,
      eventType: event.eventType,
      capacity: event.capacity,
      attendeeCount: event.attendeeCount,
      organizerName: event.organizerName,
      organizerId: event.organizerId,
      imageUrl: event.imageUrl,
      isRegistered: event.isRegistered,
      status: event.status,
    );
  }

  /// Convert to Event entity
  Event toEntity() {
    return Event(
      id: id,
      title: title,
      description: description,
      location: location,
      startDateTime: startDateTime,
      endDateTime: endDateTime,
      eventType: eventType,
      capacity: capacity,
      attendeeCount: attendeeCount,
      organizerName: organizerName,
      organizerId: organizerId,
      imageUrl: imageUrl,
      isRegistered: isRegistered,
      status: status,
    );
  }
}
