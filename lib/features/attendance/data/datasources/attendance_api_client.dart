import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/attendance_request.dart';
import '../models/attendance_response.dart';

part 'attendance_api_client.g.dart';

@RestApi()
abstract class AttendanceApiClient {
  factory AttendanceApiClient(Dio dio, {String baseUrl}) =
      _AttendanceApiClient;

  @POST('/attendance/confirm')
  Future<AttendanceResponse> confirmAttendance(
      @Body() AttendanceRequest request);
}
