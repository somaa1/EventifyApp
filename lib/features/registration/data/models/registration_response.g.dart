// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registration_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegistrationResponse _$RegistrationResponseFromJson(
  Map<String, dynamic> json,
) => RegistrationResponse(
  id: (json['id'] as num).toInt(),
  userId: (json['userId'] as num).toInt(),
  eventId: (json['eventId'] as num).toInt(),
  invitationId: (json['invitationId'] as num?)?.toInt(),
  registrationToken: json['registrationToken'] as String,
  registeredAt: DateTime.parse(json['registeredAt'] as String),
);

Map<String, dynamic> _$RegistrationResponseToJson(
  RegistrationResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'eventId': instance.eventId,
  'invitationId': instance.invitationId,
  'registrationToken': instance.registrationToken,
  'registeredAt': instance.registeredAt.toIso8601String(),
};
