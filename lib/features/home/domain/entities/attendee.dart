import 'package:equatable/equatable.dart';

class Attendee extends Equatable {
  final int id;
  final String name;
  final String email;
  final DateTime registeredAt;
  final bool attended;

  const Attendee({
    required this.id,
    required this.name,
    required this.email,
    required this.registeredAt,
    required this.attended,
  });

  @override
  List<Object?> get props => [id, name, email, registeredAt, attended];
}
