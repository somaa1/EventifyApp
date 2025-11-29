import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/user_response.dart';
import '../models/user_stats_model.dart';

part 'user_api_client.g.dart';

/// Retrofit API client for user-related endpoints
@RestApi()
abstract class UserApiClient {
  factory UserApiClient(Dio dio, {String baseUrl}) = _UserApiClient;

  /// Get current user's profile
  ///
  /// GET /api/v1/users/me
  @GET('/users/me')
  Future<UserResponse> getCurrentUser();

  /// Get current user's statistics
  ///
  /// GET /api/v1/users/me/stats
  ///
  /// Returns role-specific statistics:
  /// - ATTENDEE: registeredEvents, eventsAttended
  /// - ORGANIZER: eventsCreated, totalAttendees, upcomingEvents, pastEvents
  /// - ADMIN: all stats including totalUsers
  @GET('/users/me/stats')
  Future<UserStatsModel> getUserStats();

  /// Update current user's profile
  ///
  /// PUT /api/v1/users/me
  @PUT('/users/me')
  Future<UserResponse> updateProfile(@Body() Map<String, dynamic> userData);

  /// Get list of all users (ADMIN only)
  ///
  /// GET /api/v1/users
  @GET('/users')
  Future<List<UserResponse>> getAllUsers({
    @Query('page') int? page,
    @Query('limit') int? limit,
  });

  /// Delete a user (ADMIN only)
  ///
  /// DELETE /api/v1/users/{id}
  @DELETE('/users/{id}')
  Future<void> deleteUser(@Path('id') String id);
}
