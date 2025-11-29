import 'package:equatable/equatable.dart';
import '../../domain/entities/event.dart';

abstract class CalendarState extends Equatable {
  const CalendarState();

  @override
  List<Object?> get props => [];
}

class CalendarInitial extends CalendarState {
  const CalendarInitial();
}

class CalendarLoading extends CalendarState {
  const CalendarLoading();
}

class CalendarLoaded extends CalendarState {
  final List<Event> events;
  final DateTime selectedDay;
  final DateTime focusedDay;

  const CalendarLoaded({
    required this.events,
    required this.selectedDay,
    required this.focusedDay,
  });

  /// Get events for a specific day
  List<Event> getEventsForDay(DateTime day) {
    return events.where((event) {
      final eventDate = DateTime(
        event.startDateTime.year,
        event.startDateTime.month,
        event.startDateTime.day,
      );
      final checkDate = DateTime(day.year, day.month, day.day);
      return eventDate == checkDate;
    }).toList();
  }

  CalendarLoaded copyWith({
    List<Event>? events,
    DateTime? selectedDay,
    DateTime? focusedDay,
  }) {
    return CalendarLoaded(
      events: events ?? this.events,
      selectedDay: selectedDay ?? this.selectedDay,
      focusedDay: focusedDay ?? this.focusedDay,
    );
  }

  @override
  List<Object?> get props => [events, selectedDay, focusedDay];
}

class CalendarError extends CalendarState {
  final String message;

  const CalendarError(this.message);

  @override
  List<Object?> get props => [message];
}
