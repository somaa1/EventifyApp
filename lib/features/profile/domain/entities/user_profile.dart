import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? phone;
  final String? profileImage;
  final DateTime createdAt;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.phone,
    this.profileImage,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, email, role, phone, profileImage, createdAt];
}
