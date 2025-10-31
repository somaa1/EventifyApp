import '../entities/auth_response.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<AuthResponse> login({
    required String email,
    required String password,
  });

  Future<AuthResponse> register({
    required String name,
    required String email,
    required String password,
    required String role,
  });

  Future<AuthResponse> verifyOtp({
    required String email,
    required String otp,
  });

  Future<String> resendOtp({
    required String email,
  });

  Future<void> saveAuthToken(String token);

  Future<String?> getAuthToken();

  Future<void> saveUserInfo(User user);

  Future<User?> getUserInfo();

  Future<void> logout();

  Future<bool> isAuthenticated();
}
