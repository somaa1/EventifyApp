import 'package:equatable/equatable.dart';

class Registration extends Equatable {
  final int id;
  final int userId;
  final int eventId;
  final int? invitationId;
  final String registrationToken;
  final DateTime registeredAt;

  const Registration({
    required this.id,
    required this.userId,
    required this.eventId,
    this.invitationId,
    required this.registrationToken,
    required this.registeredAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        eventId,
        invitationId,
        registrationToken,
        registeredAt,
      ];
}
