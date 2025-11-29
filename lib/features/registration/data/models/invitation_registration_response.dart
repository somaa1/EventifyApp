import 'package:json_annotation/json_annotation.dart';

part 'invitation_registration_response.g.dart';

@JsonSerializable()
class InvitationRegistrationResponse {
  final int eventId;
  final int invitationId;

  const InvitationRegistrationResponse({
    required this.eventId,
    required this.invitationId,
  });

  factory InvitationRegistrationResponse.fromJson(Map<String, dynamic> json) =>
      _$InvitationRegistrationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$InvitationRegistrationResponseToJson(this);
}
