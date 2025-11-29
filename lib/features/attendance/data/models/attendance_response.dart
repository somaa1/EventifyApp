import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/attendance.dart';

part 'attendance_response.g.dart';

@JsonSerializable()
class AttendanceResponse extends Attendance {
  const AttendanceResponse({
    required super.id,
    required super.userId,
    required super.eventId,
    required super.registrationId,
    required super.confirmedAt,
  });

  factory AttendanceResponse.fromJson(Map<String, dynamic> json) =>
      _$AttendanceResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AttendanceResponseToJson(this);

  Attendance toEntity() {
    return Attendance(
      id: id,
      userId: userId,
      eventId: eventId,
      registrationId: registrationId,
      confirmedAt: confirmedAt,
    );
  }
}
