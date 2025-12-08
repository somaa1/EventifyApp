import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import '../../features/auth/data/datasources/auth_local_datasource.dart';

/// Interceptor that adds authentication token to requests
/// and handles 401 (Unauthorized) responses
class AuthInterceptor extends Interceptor {
  final AuthLocalDataSource _authLocalDataSource;

  AuthInterceptor(this._authLocalDataSource);

  /// List of endpoints that don't require authentication
  static const _publicEndpoints = [
    ApiConstants.login,
    ApiConstants.register,
    ApiConstants.verifyOtp,
    ApiConstants.resendOtp,
  ];

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Check if this endpoint requires authentication
    final isPublicEndpoint = _publicEndpoints.any(
      (endpoint) => options.path.contains(endpoint),
    );

    if (!isPublicEndpoint) {
      // Ensure stored token is still valid before attaching it
      final hasValidSession = await _authLocalDataSource.isAuthenticated();
      if (!hasValidSession) {
        // Skip adding an expired/invalid token; the API will respond with 401
        handler.next(options);
        return;
      }

      // Retrieve token from secure storage
      final token = await _authLocalDataSource.getAuthToken();

      if (token != null && token.isNotEmpty) {
        // Add Authorization header
        options.headers['Authorization'] = 'Bearer $token';
      }
      // If token is null, let request proceed (API will return 401)
    }

    // Continue with the request
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle 401/403 auth errors
    final statusCode = err.response?.statusCode;
    if (statusCode == 401 || statusCode == 403) {
      // Log the user out by clearing stored credentials
      _authLocalDataSource.clearAll();
    }

    // Continue with error handling
    handler.next(err);
  }
}
