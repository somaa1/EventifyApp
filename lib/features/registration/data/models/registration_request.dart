import 'package:json_annotation/json_annotation.dart';

part 'registration_request.g.dart';

@JsonSerializable()
class RegistrationRequest {
  final int eventId;
  final int? invitationId;

  const RegistrationRequest({
    required this.eventId,
    this.invitationId,
  });

  factory RegistrationRequest.fromJson(Map<String, dynamic> json) =>
      _$RegistrationRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RegistrationRequestToJson(this);
}
