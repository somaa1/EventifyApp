import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_events_usecase.dart';
import 'calendar_state.dart';

class CalendarCubit extends Cubit<CalendarState> {
  final GetEventsUseCase _getEventsUseCase;

  CalendarCubit({
    required GetEventsUseCase getEventsUseCase,
  })  : _getEventsUseCase = getEventsUseCase,
        super(const CalendarInitial());

  Future<void> loadEvents() async {
    emit(const CalendarLoading());

    try {
      final result = await _getEventsUseCase();

      result.fold(
        (failure) {
          emit(CalendarError(failure.message));
        },
        (events) {
          final now = DateTime.now();
          emit(CalendarLoaded(
            events: events,
            selectedDay: now,
            focusedDay: now,
          ));
        },
      );
    } catch (e) {
      emit(CalendarError('Failed to load events: ${e.toString()}'));
    }
  }

  void selectDay(DateTime selectedDay, DateTime focusedDay) {
    if (state is CalendarLoaded) {
      emit((state as CalendarLoaded).copyWith(
        selectedDay: selectedDay,
        focusedDay: focusedDay,
      ));
    }
  }

  Future<void> refreshEvents() async {
    await loadEvents();
  }
}
