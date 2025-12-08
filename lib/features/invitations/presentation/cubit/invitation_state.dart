import 'package:equatable/equatable.dart';
import '../../domain/entities/invitation.dart';

abstract class InvitationState extends Equatable {
  const InvitationState();

  @override
  List<Object?> get props => [];
}

class InvitationInitial extends InvitationState {
  const InvitationInitial();
}

class InvitationSending extends InvitationState {
  const InvitationSending();
}

class InvitationSent extends InvitationState {
  final Invitation invitation;
  const InvitationSent(this.invitation);

  @override
  List<Object?> get props => [invitation];
}

class InvitationError extends InvitationState {
  final String message;
  const InvitationError(this.message);

  @override
  List<Object?> get props => [message];
}
