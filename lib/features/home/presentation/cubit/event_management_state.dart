import 'package:equatable/equatable.dart';
import '../../domain/entities/event.dart';

abstract class EventManagementState extends Equatable {
  const EventManagementState();

  @override
  List<Object?> get props => [];
}

class EventManagementInitial extends EventManagementState {
  const EventManagementInitial();
}

class EventManagementLoading extends EventManagementState {
  const EventManagementLoading();
}

class EventManagementLoaded extends EventManagementState {
  final List<Event> events;
  const EventManagementLoaded(this.events);

  @override
  List<Object?> get props => [events];
}

class EventManagementError extends EventManagementState {
  final String message;
  const EventManagementError(this.message);

  @override
  List<Object?> get props => [message];
}
