import 'package:equatable/equatable.dart';
import '../../domain/entities/attendee.dart';

abstract class AttendeesState extends Equatable {
  const AttendeesState();

  @override
  List<Object?> get props => [];
}

class AttendeesInitial extends AttendeesState {
  const AttendeesInitial();
}

class AttendeesLoading extends AttendeesState {
  const AttendeesLoading();
}

class AttendeesLoaded extends AttendeesState {
  final List<Attendee> attendees;
  const AttendeesLoaded(this.attendees);

  @override
  List<Object?> get props => [attendees];
}

class AttendeesError extends AttendeesState {
  final String message;
  const AttendeesError(this.message);

  @override
  List<Object?> get props => [message];
}
