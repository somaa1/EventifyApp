// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invitation_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvitationResponse _$InvitationResponseFromJson(Map<String, dynamic> json) =>
    InvitationResponse(
      id: (json['id'] as num).toInt(),
      eventId: (json['eventId'] as num).toInt(),
      email: json['email'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$InvitationResponseToJson(InvitationResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'eventId': instance.eventId,
      'email': instance.email,
      'status': instance.status,
    };
