import 'package:equatable/equatable.dart';

class Attendance extends Equatable {
  final int id;
  final int userId;
  final int eventId;
  final int registrationId;
  final DateTime confirmedAt;

  const Attendance({
    required this.id,
    required this.userId,
    required this.eventId,
    required this.registrationId,
    required this.confirmedAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        eventId,
        registrationId,
        confirmedAt,
      ];
}
