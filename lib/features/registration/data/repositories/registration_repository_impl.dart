import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/registration.dart';
import '../../domain/repositories/registration_repository.dart';
import '../datasources/registration_api_client.dart';
import '../models/registration_request.dart';

/// Implementation of RegistrationRepository
class RegistrationRepositoryImpl implements RegistrationRepository {
  final RegistrationApiClient _apiClient;

  RegistrationRepositoryImpl(this._apiClient);

  @override
  Future<Either<Failure, Registration>> registerForEvent({
    required int eventId,
    int? invitationId,
  }) async {
    try {
      final request = RegistrationRequest(
        eventId: eventId,
        invitationId: invitationId,
      );

      final response = await _apiClient.registerForEvent(request);
      return Right(response.toEntity());
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(
          ServerFailure('Failed to register for event: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Registration>> getRegistrationByToken(
      String token) async {
    try {
      final response = await _apiClient.getRegistrationByToken(token);
      return Right(response.toEntity());
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(
          ServerFailure('Failed to fetch registration: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Map<String, int>>> getRegistrationByInvitation(
      String token) async {
    try {
      final response = await _apiClient.getRegistrationByInvitation(token);
      return Right({
        'eventId': response.eventId,
        'invitationId': response.invitationId,
      });
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(
          'Failed to fetch registration by invitation: ${e.toString()}'));
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
          return ServerFailure('Registration not found.');
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
