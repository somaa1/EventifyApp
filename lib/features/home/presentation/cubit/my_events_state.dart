import 'package:equatable/equatable.dart';
import '../../domain/entities/event.dart';

abstract class MyEventsState extends Equatable {
  const MyEventsState();

  @override
  List<Object?> get props => [];
}

class MyEventsInitial extends MyEventsState {
  const MyEventsInitial();
}

class MyEventsLoading extends MyEventsState {
  const MyEventsLoading();
}

class MyEventsLoaded extends MyEventsState {
  final List<Event> upcomingEvents;
  final List<Event> pastEvents;

  const MyEventsLoaded({
    required this.upcomingEvents,
    required this.pastEvents,
  });

  @override
  List<Object?> get props => [upcomingEvents, pastEvents];
}

class MyEventsError extends MyEventsState {
  final String message;

  const MyEventsError(this.message);

  @override
  List<Object?> get props => [message];
}
