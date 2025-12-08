import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/event_repository.dart';

class DeleteEventUseCase {
  final EventRepository repository;
  const DeleteEventUseCase(this.repository);

  Future<Either<Failure, void>> call(String id) {
    return repository.deleteEvent(id);
  }
}
