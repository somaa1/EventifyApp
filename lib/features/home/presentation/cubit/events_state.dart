import 'package:equatable/equatable.dart';
import '../../domain/entities/event.dart';
import '../../domain/entities/event_filter.dart';

/// States for EventsCubit
abstract class EventsState extends Equatable {
  const EventsState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class EventsInitial extends EventsState {
  const EventsInitial();
}

/// Loading state
class EventsLoading extends EventsState {
  const EventsLoading();
}

/// Refreshing state (for pull-to-refresh)
class EventsRefreshing extends EventsState {
  final List<Event> currentEvents;

  const EventsRefreshing(this.currentEvents);

  @override
  List<Object?> get props => [currentEvents];
}

/// Loaded state with events
class EventsLoaded extends EventsState {
  final List<Event> events;
  final EventFilter activeFilter;
  final bool hasMore;
  final int currentPage;

  const EventsLoaded({
    required this.events,
    this.activeFilter = EventFilter.empty,
    this.hasMore = true,
    this.currentPage = 1,
  });

  /// Copy with updated fields
  EventsLoaded copyWith({
    List<Event>? events,
    EventFilter? activeFilter,
    bool? hasMore,
    int? currentPage,
  }) {
    return EventsLoaded(
      events: events ?? this.events,
      activeFilter: activeFilter ?? this.activeFilter,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object?> get props => [events, activeFilter, hasMore, currentPage];
}

/// Loading more state (for pagination)
class EventsLoadingMore extends EventsState {
  final List<Event> currentEvents;
  final EventFilter activeFilter;
  final int currentPage;

  const EventsLoadingMore({
    required this.currentEvents,
    required this.activeFilter,
    required this.currentPage,
  });

  @override
  List<Object?> get props => [currentEvents, activeFilter, currentPage];
}

/// Error state
class EventsError extends EventsState {
  final String message;
  final List<Event>? currentEvents;

  const EventsError(this.message, {this.currentEvents});

  @override
  List<Object?> get props => [message, currentEvents];
}

/// Empty state (no events found)
class EventsEmpty extends EventsState {
  final EventFilter activeFilter;

  const EventsEmpty({this.activeFilter = EventFilter.empty});

  @override
  List<Object?> get props => [activeFilter];
}
