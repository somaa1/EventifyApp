import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String? id;
  final String name;
  final String email;
  final String role;

  const User({
    this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  bool get isAttendee => role == 'ATTENDEE';
  bool get isOrganizer => role == 'ORGANIZER';
  bool get isAdmin => role == 'ADMIN';

  @override
  List<Object?> get props => [id, name, email, role];
}
