import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/registration.dart';

part 'registration_response.g.dart';

@JsonSerializable()
class RegistrationResponse extends Registration {
  const RegistrationResponse({
    required super.id,
    required super.userId,
    required super.eventId,
    super.invitationId,
    required super.registrationToken,
    required super.registeredAt,
  });

  factory RegistrationResponse.fromJson(Map<String, dynamic> json) =>
      _$RegistrationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RegistrationResponseToJson(this);

  Registration toEntity() {
    return Registration(
      id: id,
      userId: userId,
      eventId: eventId,
      invitationId: invitationId,
      registrationToken: registrationToken,
      registeredAt: registeredAt,
    );
  }
}
