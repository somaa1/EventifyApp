import '../../domain/entities/auth_response.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_api_client.dart';
import '../datasources/auth_local_datasource.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiClient apiClient;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.apiClient,
    required this.localDataSource,
  });

  @override
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final request = LoginRequest(email: email, password: password);
      final response = await apiClient.login(request);

      // Save token and user info if login successful
      if (response.token != null) {
        await saveAuthToken(response.token!);
        await saveUserInfo(User(
          name: response.name,
          email: email,
          role: response.role,
        ));
      }

      return response.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AuthResponse> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final request = RegisterRequest(
        name: name,
        email: email,
        password: password,
        role: role,
      );
      final response = await apiClient.register(request);

      // Note: Token will be null, OTP verification required
      // We save the email temporarily for OTP verification screen
      await localDataSource.sharedPreferences.setString('temp_email', email);

      return response.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AuthResponse> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await apiClient.verifyOtp(email, otp);

      // Save token and user info after successful OTP verification
      if (response.token != null) {
        await saveAuthToken(response.token!);
        await saveUserInfo(User(
          name: response.name,
          email: email,
          role: response.role,
        ));

        // Clear temporary email
        await localDataSource.sharedPreferences.remove('temp_email');
      }

      return response.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> resendOtp({required String email}) async {
    try {
      return await apiClient.resendOtp(email);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> saveAuthToken(String token) async {
    await localDataSource.saveAuthToken(token);
  }

  @override
  Future<String?> getAuthToken() async {
    return await localDataSource.getAuthToken();
  }

  @override
  Future<void> saveUserInfo(User user) async {
    await localDataSource.saveUserInfo(user);
  }

  @override
  Future<User?> getUserInfo() async {
    return await localDataSource.getUserInfo();
  }

  @override
  Future<void> logout() async {
    await localDataSource.clearAll();
  }

  @override
  Future<bool> isAuthenticated() async {
    return await localDataSource.isAuthenticated();
  }
}
