import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_stats.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_api_client.dart';
import '../../../profile/domain/entities/user_profile.dart';
import '../models/user_response.dart';

/// Implementation of UserRepository
class UserRepositoryImpl implements UserRepository {
  final UserApiClient _apiClient;

  UserRepositoryImpl(this._apiClient);

  @override
  Future<Either<Failure, UserStats>> getUserStats() async {
    try {
      final statsModel = await _apiClient.getUserStats();
      return Right(statsModel.toEntity());
    } on DioException catch (e) {
      // If backend stats endpoint is temporarily failing, fall back to empty stats
      if (e.response?.statusCode == 500) {
        return const Right(UserStats.empty);
      }
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Failed to fetch user stats: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> getCurrentUser() async {
    try {
      final userResponse = await _apiClient.getCurrentUser();
      return Right(_mapToProfile(userResponse));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Failed to fetch user data: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> updateProfile(
    Map<String, dynamic> data,
  ) async {
    try {
      final userResponse = await _apiClient.updateProfile(data);
      return Right(_mapToProfile(userResponse));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Failed to update profile: ${e.toString()}'));
    }
  }

  UserProfile _mapToProfile(UserResponse response) {
    return UserProfile(
      id: response.id,
      name: response.name,
      email: response.email,
      role: response.role,
      phone: response.phone,
      profileImage: response.profileImage,
      createdAt: response.createdAt,
    );
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
        final responseData = error.response?.data;
        final message = responseData is Map<String, dynamic> &&
                responseData['message'] is String
            ? responseData['message'] as String
            : 'An error occurred';
        if (statusCode == 401) {
          return AuthFailure('Unauthorized. Please login again.');
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
