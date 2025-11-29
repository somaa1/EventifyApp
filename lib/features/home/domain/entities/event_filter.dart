import 'package:equatable/equatable.dart';

/// Filter criteria for events list
class EventFilter extends Equatable {
  /// Search query for event title, description, or location
  final String? searchQuery;

  /// Filter by event type (CONFERENCE, WORKSHOP, MEETUP, etc.)
  final String? eventType;

  /// Filter events starting from this date
  final DateTime? startDate;

  /// Filter events ending before this date
  final DateTime? endDate;

  /// Whether to show past events
  final bool showPastEvents;

  /// Sort by field (title, date, attendees, etc.)
  final String sortBy;

  /// Sort order (asc or desc)
  final String sortOrder;

  const EventFilter({
    this.searchQuery,
    this.eventType,
    this.startDate,
    this.endDate,
    this.showPastEvents = false,
    this.sortBy = 'date',
    this.sortOrder = 'asc',
  });

  /// Default empty filter
  static const empty = EventFilter();

  /// Check if any filter is active
  bool get hasActiveFilters =>
      searchQuery != null ||
      eventType != null ||
      startDate != null ||
      endDate != null ||
      showPastEvents;

  /// Create a copy with updated fields
  EventFilter copyWith({
    String? searchQuery,
    String? eventType,
    DateTime? startDate,
    DateTime? endDate,
    bool? showPastEvents,
    String? sortBy,
    String? sortOrder,
  }) {
    return EventFilter(
      searchQuery: searchQuery ?? this.searchQuery,
      eventType: eventType ?? this.eventType,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      showPastEvents: showPastEvents ?? this.showPastEvents,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  /// Clear all filters
  EventFilter clearFilters() {
    return const EventFilter();
  }

  @override
  List<Object?> get props => [
        searchQuery,
        eventType,
        startDate,
        endDate,
        showPastEvents,
        sortBy,
        sortOrder,
      ];
}
