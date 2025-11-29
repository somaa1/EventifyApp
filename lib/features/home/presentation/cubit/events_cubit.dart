import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/event_filter.dart';
import '../../domain/usecases/get_events_usecase.dart';
import 'events_state.dart';

/// Cubit for managing events list state
class EventsCubit extends Cubit<EventsState> {
  final GetEventsUseCase _getEventsUseCase;
  static const int _pageSize = 20;

  EventsCubit({
    required GetEventsUseCase getEventsUseCase,
  })  : _getEventsUseCase = getEventsUseCase,
        super(const EventsInitial());

  /// Load events with optional filter
  Future<void> loadEvents({EventFilter filter = EventFilter.empty}) async {
    emit(const EventsLoading());

    final result = await _getEventsUseCase(
      filter: filter,
      page: 1,
      limit: _pageSize,
    );

    result.fold(
      (failure) {
        emit(EventsError(failure.message));
      },
      (events) {
        if (events.isEmpty) {
          emit(EventsEmpty(activeFilter: filter));
        } else {
          emit(EventsLoaded(
            events: events,
            activeFilter: filter,
            hasMore: events.length >= _pageSize,
            currentPage: 1,
          ));
        }
      },
    );
  }

  /// Refresh events (for pull-to-refresh)
  Future<void> refresh() async {
    final currentState = state;
    final filter = currentState is EventsLoaded
        ? currentState.activeFilter
        : EventFilter.empty;

    if (currentState is EventsLoaded) {
      emit(EventsRefreshing(currentState.events));
    }

    final result = await _getEventsUseCase(
      filter: filter,
      page: 1,
      limit: _pageSize,
    );

    result.fold(
      (failure) {
        emit(EventsError(
          failure.message,
          currentEvents:
              currentState is EventsLoaded ? currentState.events : null,
        ));
      },
      (events) {
        if (events.isEmpty) {
          emit(EventsEmpty(activeFilter: filter));
        } else {
          emit(EventsLoaded(
            events: events,
            activeFilter: filter,
            hasMore: events.length >= _pageSize,
            currentPage: 1,
          ));
        }
      },
    );
  }

  /// Load more events (pagination)
  Future<void> loadMore() async {
    final currentState = state;
    if (currentState is! EventsLoaded || !currentState.hasMore) {
      return;
    }

    final nextPage = currentState.currentPage + 1;

    emit(EventsLoadingMore(
      currentEvents: currentState.events,
      activeFilter: currentState.activeFilter,
      currentPage: currentState.currentPage,
    ));

    final result = await _getEventsUseCase(
      filter: currentState.activeFilter,
      page: nextPage,
      limit: _pageSize,
    );

    result.fold(
      (failure) {
        emit(EventsError(
          failure.message,
          currentEvents: currentState.events,
        ));
      },
      (newEvents) {
        final allEvents = [...currentState.events, ...newEvents];
        emit(EventsLoaded(
          events: allEvents,
          activeFilter: currentState.activeFilter,
          hasMore: newEvents.length >= _pageSize,
          currentPage: nextPage,
        ));
      },
    );
  }

  /// Apply filter to events
  Future<void> applyFilter(EventFilter filter) async {
    await loadEvents(filter: filter);
  }

  /// Clear all filters
  Future<void> clearFilters() async {
    await loadEvents(filter: EventFilter.empty);
  }

  /// Search events by query
  Future<void> search(String query) async {
    if (query.isEmpty) {
      await clearFilters();
      return;
    }

    final filter = EventFilter(searchQuery: query);
    await loadEvents(filter: filter);
  }
}
