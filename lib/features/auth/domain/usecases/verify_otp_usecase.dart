import '../entities/auth_response.dart';
import '../repositories/auth_repository.dart';

class VerifyOtpUseCase {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  Future<AuthResponse> call({
    required String email,
    required String otp,
  }) async {
    return await repository.verifyOtp(email: email, otp: otp);
  }
}
