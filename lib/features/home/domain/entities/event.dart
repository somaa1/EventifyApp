import 'package:equatable/equatable.dart';

/// Event entity representing an event in the domain layer
class Event extends Equatable {
  /// Unique identifier for the event
  final String id;

  /// Event title
  final String title;

  /// Event description
  final String description;

  /// Event location
  final String location;

  /// Event start date and time
  final DateTime startDateTime;

  /// Event end date and time
  final DateTime endDateTime;

  /// Type of event (e.g., CONFERENCE, WORKSHOP, MEETUP, etc.)
  final String eventType;

  /// Maximum capacity of attendees
  final int capacity;

  /// Current number of registered attendees
  final int attendeeCount;

  /// Name of the event organizer
  final String organizerName;

  /// ID of the organizer
  final String organizerId;

  /// Image URL for the event
  final String? imageUrl;

  /// Whether the current user is registered for this event
  final bool isRegistered;

  /// Event status (UPCOMING, ONGOING, COMPLETED, CANCELLED)
  final String status;

  const Event({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.startDateTime,
    required this.endDateTime,
    required this.eventType,
    this.capacity = 0,           // Default to 0 when missing from backend
    this.attendeeCount = 0,      // Default to 0 when missing from backend
    this.organizerName = '',     // Default to empty when missing from backend
    this.organizerId = '',       // Default to empty when missing from backend
    this.imageUrl,
    this.isRegistered = false,
    this.status = 'UPCOMING',    // Default to UPCOMING when missing from backend
  });

  /// Check if event is full
  bool get isFull => capacity > 0 && attendeeCount >= capacity;

  /// Get remaining spots
  int get remainingSpots {
    if (capacity <= 0) return 0;
    final remaining = capacity - attendeeCount;
    return remaining < 0 ? 0 : remaining;
  }

  /// Check if event is in the future
  bool get isUpcoming => startDateTime.isAfter(DateTime.now());

  /// Check if event is currently ongoing
  bool get isOngoing {
    final now = DateTime.now();
    return now.isAfter(startDateTime) && now.isBefore(endDateTime);
  }

  /// Check if event is in the past
  bool get isPast => endDateTime.isBefore(DateTime.now());

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        location,
        startDateTime,
        endDateTime,
        eventType,
        capacity,
        attendeeCount,
        organizerName,
        organizerId,
        imageUrl,
        isRegistered,
        status,
      ];
}
