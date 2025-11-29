import 'package:equatable/equatable.dart';
import '../../domain/entities/event.dart';

abstract class EventDetailsState extends Equatable {
  const EventDetailsState();

  @override
  List<Object?> get props => [];
}

class EventDetailsInitial extends EventDetailsState {
  const EventDetailsInitial();
}

class EventDetailsLoading extends EventDetailsState {
  const EventDetailsLoading();
}

class EventDetailsLoaded extends EventDetailsState {
  final Event event;

  const EventDetailsLoaded(this.event);

  @override
  List<Object?> get props => [event];
}

class EventDetailsError extends EventDetailsState {
  final String message;

  const EventDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
