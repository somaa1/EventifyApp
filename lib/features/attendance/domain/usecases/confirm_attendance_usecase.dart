import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/attendance.dart';
import '../repositories/attendance_repository.dart';

class ConfirmAttendanceUseCase {
  final AttendanceRepository repository;

  const ConfirmAttendanceUseCase(this.repository);

  Future<Either<Failure, Attendance>> call(String token) {
    return repository.confirmAttendance(token);
  }
}
