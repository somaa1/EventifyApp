import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/attendance.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../datasources/attendance_api_client.dart';
import '../models/attendance_request.dart';

/// Implementation of AttendanceRepository
class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceApiClient _apiClient;

  AttendanceRepositoryImpl(this._apiClient);

  @override
  Future<Either<Failure, Attendance>> confirmAttendance(String token) async {
    try {
      final request = AttendanceRequest(token: token);
      final response = await _apiClient.confirmAttendance(request);
      return Right(response.toEntity());
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(
          ServerFailure('Failed to confirm attendance: ${e.toString()}'));
    }
  }

  /// Handle Dio errors and convert to appropriate Failures
  Failure _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ServerFailure('Connection timeout. Please try again.');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data['message'] ?? 'An error occurred';
        if (statusCode == 401) {
          return AuthFailure('Unauthorized. Please login again.');
        } else if (statusCode == 404) {
          return ServerFailure('Attendance record not found.');
        } else if (statusCode == 400) {
          return ServerFailure(message);
        } else {
          return ServerFailure(message);
        }
      case DioExceptionType.cancel:
        return ServerFailure('Request cancelled.');
      case DioExceptionType.connectionError:
        return NetworkFailure('No internet connection.');
      default:
        return ServerFailure('An unexpected error occurred.');
    }
  }
}
