import 'package:json_annotation/json_annotation.dart';

part 'user_response.g.dart';

/// Response model for user data from /users/me endpoint
@JsonSerializable()
class UserResponse {
  /// User ID
  final String id;

  /// User name
  final String name;

  /// User email
  final String email;

  /// User role (ATTENDEE, ORGANIZER, ADMIN)
  final String role;

  /// Phone number
  final String? phone;

  /// Profile image URL
  final String? profileImage;

  /// Account creation date
  final DateTime createdAt;

  /// Last update date
  final DateTime updatedAt;

  const UserResponse({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.phone,
    this.profileImage,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create UserResponse from JSON
  factory UserResponse.fromJson(Map<String, dynamic> json) =>
      _$UserResponseFromJson(json);

  /// Convert UserResponse to JSON
  Map<String, dynamic> toJson() => _$UserResponseToJson(this);
}
