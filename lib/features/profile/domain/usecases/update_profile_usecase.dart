import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../home/domain/repositories/user_repository.dart';
import '../entities/user_profile.dart';

class UpdateProfileUseCase {
  final UserRepository repository;
  const UpdateProfileUseCase(this.repository);

  Future<Either<Failure, UserProfile>> call(Map<String, dynamic> data) {
    return repository.updateProfile(data);
  }
}
