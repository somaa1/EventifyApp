import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/user.dart';
import '../../../../core/constants/app_constants.dart';

class AuthLocalDataSource {
  final FlutterSecureStorage secureStorage;
  final SharedPreferences sharedPreferences;

  AuthLocalDataSource({
    required this.secureStorage,
    required this.sharedPreferences,
  });

  // Token management
  Future<void> saveAuthToken(String token) async {
    await secureStorage.write(key: AppConstants.keyToken, value: token);
  }

  Future<String?> getAuthToken() async {
    return await secureStorage.read(key: AppConstants.keyToken);
  }

  Future<void> deleteAuthToken() async {
    await secureStorage.delete(key: AppConstants.keyToken);
  }

  // User info management
  Future<void> saveUserInfo(User user) async {
    await sharedPreferences.setString(AppConstants.keyUserName, user.name);
    await sharedPreferences.setString(AppConstants.keyUserEmail, user.email);
    await sharedPreferences.setString(AppConstants.keyUserRole, user.role);
  }

  Future<User?> getUserInfo() async {
    final name = sharedPreferences.getString(AppConstants.keyUserName);
    final email = sharedPreferences.getString(AppConstants.keyUserEmail);
    final role = sharedPreferences.getString(AppConstants.keyUserRole);

    if (name == null || email == null || role == null) {
      return null;
    }

    return User(name: name, email: email, role: role);
  }

  Future<void> deleteUserInfo() async {
    await sharedPreferences.remove(AppConstants.keyUserName);
    await sharedPreferences.remove(AppConstants.keyUserEmail);
    await sharedPreferences.remove(AppConstants.keyUserRole);
  }

  Future<bool> isAuthenticated() async {
    final token = await getAuthToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> clearAll() async {
    await deleteAuthToken();
    await deleteUserInfo();
  }
}
