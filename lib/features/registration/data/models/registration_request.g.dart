// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registration_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegistrationRequest _$RegistrationRequestFromJson(Map<String, dynamic> json) =>
    RegistrationRequest(
      eventId: (json['eventId'] as num).toInt(),
      invitationId: (json['invitationId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RegistrationRequestToJson(
  RegistrationRequest instance,
) => <String, dynamic>{
  'eventId': instance.eventId,
  'invitationId': instance.invitationId,
};
