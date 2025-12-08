import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/confirm_attendance_usecase.dart';
import 'attendance_state.dart';

class AttendanceCubit extends Cubit<AttendanceState> {
  final ConfirmAttendanceUseCase confirmAttendanceUseCase;

  AttendanceCubit({required this.confirmAttendanceUseCase})
      : super(const AttendanceInitial());

  Future<void> confirmAttendance(String registrationToken) async {
    emit(const AttendanceLoading());
    final result = await confirmAttendanceUseCase(registrationToken);
    result.fold(
      (failure) => emit(AttendanceError(failure.message)),
      (attendance) => emit(AttendanceSuccess(attendance)),
    );
  }

  void reset() => emit(const AttendanceInitial());
}
