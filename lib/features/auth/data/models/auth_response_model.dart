import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/auth_response.dart';

part 'auth_response_model.g.dart';

@JsonSerializable()
class AuthResponseModel extends AuthResponse {
  const AuthResponseModel({
    super.token,
    required super.name,
    required super.role,
    required super.message,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseModelToJson(this);

  AuthResponse toEntity() {
    return AuthResponse(
      token: token,
      name: name,
      role: role,
      message: message,
    );
  }
}
