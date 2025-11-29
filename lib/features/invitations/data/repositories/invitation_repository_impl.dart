import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/invitation.dart';
import '../../domain/repositories/invitation_repository.dart';
import '../datasources/invitation_api_client.dart';

/// Implementation of InvitationRepository
class InvitationRepositoryImpl implements InvitationRepository {
  final InvitationApiClient _apiClient;

  InvitationRepositoryImpl(this._apiClient);

  @override
  Future<Either<Failure, Invitation>> sendInvitation({
    required int eventId,
    required String email,
  }) async {
    try {
      final response = await _apiClient.sendInvitation(eventId, email);
      return Right(response.toEntity());
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Failed to send invitation: ${e.toString()}'));
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
          return ServerFailure('Event not found.');
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
