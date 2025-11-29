import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/attendance.dart';

/// Repository interface for attendance-related operations
abstract class AttendanceRepository {
  /// Confirm attendance via QR code token
  ///
  /// Returns [Right<Attendance>] on success
  /// Returns [Left<Failure>] on error
  Future<Either<Failure, Attendance>> confirmAttendance(String token);
}
