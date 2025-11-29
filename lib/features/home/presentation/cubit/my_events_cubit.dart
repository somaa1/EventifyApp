import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_registered_events_usecase.dart';
import 'my_events_state.dart';

class MyEventsCubit extends Cubit<MyEventsState> {
  final GetRegisteredEventsUseCase _getRegisteredEventsUseCase;

  MyEventsCubit({
    required GetRegisteredEventsUseCase getRegisteredEventsUseCase,
  })  : _getRegisteredEventsUseCase = getRegisteredEventsUseCase,
        super(const MyEventsInitial());

  Future<void> loadMyEvents() async {
    emit(const MyEventsLoading());

    try {
      final result = await _getRegisteredEventsUseCase();

      result.fold(
        (failure) {
          emit(MyEventsError(failure.message));
        },
        (events) {
          // Split events into upcoming and past
          final now = DateTime.now();
          final upcoming = events
              .where((event) => event.startDateTime.isAfter(now))
              .toList();
          final past = events
              .where((event) => event.startDateTime.isBefore(now))
              .toList();

          // Sort upcoming events by date (earliest first)
          upcoming.sort((a, b) => a.startDateTime.compareTo(b.startDateTime));

          // Sort past events by date (most recent first)
          past.sort((a, b) => b.startDateTime.compareTo(a.startDateTime));

          emit(MyEventsLoaded(
            upcomingEvents: upcoming,
            pastEvents: past,
          ));
        },
      );
    } catch (e) {
      emit(MyEventsError('Failed to load events: ${e.toString()}'));
    }
  }

  Future<void> refreshMyEvents() async {
    await loadMyEvents();
  }
}
