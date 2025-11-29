import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/registration.dart';
import '../repositories/registration_repository.dart';

class GetRegistrationByTokenUseCase {
  final RegistrationRepository repository;

  const GetRegistrationByTokenUseCase(this.repository);

  Future<Either<Failure, Registration>> call(String token) {
    return repository.getRegistrationByToken(token);
  }
}
