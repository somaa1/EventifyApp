import 'package:json_annotation/json_annotation.dart';
import 'event_model.dart';

part 'events_response.g.dart';

/// Response model for paginated events list
@JsonSerializable()
class EventsResponse {
  /// List of events
  final List<EventModel> events;

  /// Total number of events
  final int total;

  /// Current page number
  final int page;

  /// Number of items per page
  final int limit;

  /// Total number of pages
  final int totalPages;

  const EventsResponse({
    required this.events,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  /// Create EventsResponse from JSON
  factory EventsResponse.fromJson(Map<String, dynamic> json) =>
      _$EventsResponseFromJson(json);

  /// Convert EventsResponse to JSON
  Map<String, dynamic> toJson() => _$EventsResponseToJson(this);
}
