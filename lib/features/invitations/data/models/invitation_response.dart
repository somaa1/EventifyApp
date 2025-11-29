import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/invitation.dart';

part 'invitation_response.g.dart';

@JsonSerializable()
class InvitationResponse extends Invitation {
  const InvitationResponse({
    required super.id,
    required super.eventId,
    required super.email,
    required super.status,
  });

  factory InvitationResponse.fromJson(Map<String, dynamic> json) =>
      _$InvitationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$InvitationResponseToJson(this);

  Invitation toEntity() {
    return Invitation(
      id: id,
      eventId: eventId,
      email: email,
      status: status,
    );
  }
}
