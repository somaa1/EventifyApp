import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/attendee.dart';

part 'event_attendee_model.g.dart';

@JsonSerializable()
class EventAttendeeModel extends Attendee {
  const EventAttendeeModel({
    required super.id,
    required super.name,
    required super.email,
    required super.registeredAt,
    required super.attended,
  });

  factory EventAttendeeModel.fromJson(Map<String, dynamic> json) =>
      _$EventAttendeeModelFromJson(json);

  Map<String, dynamic> toJson() => _$EventAttendeeModelToJson(this);
}
