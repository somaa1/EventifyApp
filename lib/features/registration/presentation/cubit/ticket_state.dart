import 'package:equatable/equatable.dart';
import '../../domain/entities/registration.dart';
import '../../../home/domain/entities/event.dart';

abstract class TicketState extends Equatable {
  const TicketState();

  @override
  List<Object?> get props => [];
}

class TicketInitial extends TicketState {
  const TicketInitial();
}

class TicketLoading extends TicketState {
  const TicketLoading();
}

class TicketLoaded extends TicketState {
  final Registration registration;
  final Event event;

  const TicketLoaded({
    required this.registration,
    required this.event,
  });

  @override
  List<Object?> get props => [registration, event];
}

class TicketError extends TicketState {
  final String message;

  const TicketError(this.message);

  @override
  List<Object?> get props => [message];
}
