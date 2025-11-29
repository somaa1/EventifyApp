import 'package:json_annotation/json_annotation.dart';

part 'attendance_request.g.dart';

@JsonSerializable()
class AttendanceRequest {
  final String token;

  const AttendanceRequest({
    required this.token,
  });

  factory AttendanceRequest.fromJson(Map<String, dynamic> json) =>
      _$AttendanceRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AttendanceRequestToJson(this);
}
