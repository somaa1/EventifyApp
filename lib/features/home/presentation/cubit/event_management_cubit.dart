import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_my_events_usecase.dart';
import '../../domain/usecases/delete_event_usecase.dart';
import 'event_management_state.dart';

class EventManagementCubit extends Cubit<EventManagementState> {
  final GetMyEventsUseCase getMyEventsUseCase;
  final DeleteEventUseCase deleteEventUseCase;

  EventManagementCubit({
    required this.getMyEventsUseCase,
    required this.deleteEventUseCase,
  }) : super(const EventManagementInitial());

  Future<void> loadEvents() async {
    emit(const EventManagementLoading());
    final result = await getMyEventsUseCase();
    result.fold(
      (failure) => emit(EventManagementError(failure.message)),
      (events) => emit(EventManagementLoaded(events)),
    );
  }

  Future<void> refresh() => loadEvents();

  Future<void> deleteEvent(String id) async {
    final currentState = state;

    // Only proceed if we have events loaded
    if (currentState is! EventManagementLoaded) {
      return;
    }

    // Emit deleting state with current events still visible
    emit(EventManagementDeleting(currentState.events, id));

    final result = await deleteEventUseCase(id);

    result.fold(
      (failure) {
        // Improved error handling
        String errorMessage = failure.message;

        // Check for specific error types
        if (errorMessage.contains('500') ||
            errorMessage.contains('Internal Server Error')) {
          errorMessage =
              'Server error: Unable to delete event. This is a backend issue. Please try again later.';
        } else if (errorMessage.contains('Network') ||
            errorMessage.contains('connection')) {
          errorMessage =
              'No internet connection. Please check your network and try again.';
        } else if (errorMessage.contains('404')) {
          errorMessage = 'Event not found. It may have been deleted already.';
        }

        // Keep the current events visible and show error
        emit(EventManagementLoaded(currentState.events));
        emit(EventManagementError(errorMessage));

        // Return to loaded state after 3 seconds so error doesn't persist
        Future.delayed(const Duration(seconds: 3), () {
          if (state is EventManagementError) {
            emit(EventManagementLoaded(currentState.events));
          }
        });
      },
      (_) {
        // Success: remove deleted event from list
        final updatedEvents =
            currentState.events.where((event) => event.id != id).toList();
        emit(EventManagementLoaded(updatedEvents));
      },
    );
  }
}
