import 'package:equatable/equatable.dart';

class Invitation extends Equatable {
  final int id;
  final int eventId;
  final String email;
  final String status; // PENDING, ACCEPTED, DECLINED

  const Invitation({
    required this.id,
    required this.eventId,
    required this.email,
    required this.status,
  });

  @override
  List<Object?> get props => [
        id,
        eventId,
        email,
        status,
      ];
}
