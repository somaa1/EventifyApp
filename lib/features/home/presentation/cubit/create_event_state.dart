import 'package:equatable/equatable.dart';
import '../../domain/entities/event.dart';

abstract class CreateEventState extends Equatable {
  const CreateEventState();

  @override
  List<Object?> get props => [];
}

class CreateEventInitial extends CreateEventState {
  const CreateEventInitial();
}

class CreateEventSubmitting extends CreateEventState {
  const CreateEventSubmitting();
}

class CreateEventSuccess extends CreateEventState {
  final Event event;
  const CreateEventSuccess(this.event);

  @override
  List<Object?> get props => [event];
}

class CreateEventError extends CreateEventState {
  final String message;
  const CreateEventError(this.message);

  @override
  List<Object?> get props => [message];
}
