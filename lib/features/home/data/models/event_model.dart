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

  /// Create EventModel from JSON
  factory EventModel.fromJson(Map<String, dynamic> json) =>
      _$EventModelFromJson(json);

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
