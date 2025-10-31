import '../repositories/auth_repository.dart';

class ResendOtpUseCase {
  final AuthRepository repository;

  ResendOtpUseCase(this.repository);

  Future<String> call({required String email}) async {
    return await repository.resendOtp(email: email);
  }
}
