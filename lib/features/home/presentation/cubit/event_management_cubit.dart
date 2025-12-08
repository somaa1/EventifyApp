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
    emit(const EventManagementLoading());
    final result = await deleteEventUseCase(id);
    result.fold(
      (failure) => emit(EventManagementError(failure.message)),
      (_) async {
        if (currentState is EventManagementLoaded) {
          final updatedEvents =
              currentState.events.where((event) => event.id != id).toList();
          emit(EventManagementLoaded(updatedEvents));
        } else {
          await loadEvents();
        }
      },
    );
  }
}
