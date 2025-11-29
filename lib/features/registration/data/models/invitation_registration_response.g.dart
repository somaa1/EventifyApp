// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invitation_registration_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvitationRegistrationResponse _$InvitationRegistrationResponseFromJson(
  Map<String, dynamic> json,
) => InvitationRegistrationResponse(
  eventId: (json['eventId'] as num).toInt(),
  invitationId: (json['invitationId'] as num).toInt(),
);

Map<String, dynamic> _$InvitationRegistrationResponseToJson(
  InvitationRegistrationResponse instance,
) => <String, dynamic>{
  'eventId': instance.eventId,
  'invitationId': instance.invitationId,
};
