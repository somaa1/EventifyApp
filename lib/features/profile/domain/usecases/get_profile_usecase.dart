import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../home/domain/repositories/user_repository.dart';
import '../entities/user_profile.dart';

class GetProfileUseCase {
  final UserRepository repository;
  const GetProfileUseCase(this.repository);

  Future<Either<Failure, UserProfile>> call() {
    return repository.getCurrentUser();
  }
}
