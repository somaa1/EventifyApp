import '../entities/auth_response.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<AuthResponse> call({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    return await repository.register(
      name: name,
      email: email,
      password: password,
      role: role,
    );
  }
}
