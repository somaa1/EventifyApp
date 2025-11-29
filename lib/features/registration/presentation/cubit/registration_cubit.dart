import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/register_for_event_usecase.dart';
import 'registration_state.dart';

class RegistrationCubit extends Cubit<RegistrationState> {
  final RegisterForEventUseCase registerForEventUseCase;

  RegistrationCubit({
    required this.registerForEventUseCase,
  }) : super(const RegistrationInitial());

  Future<void> registerForEvent({
    required int eventId,
    int? invitationId,
  }) async {
    emit(const RegistrationLoading());

    final result = await registerForEventUseCase(
      eventId: eventId,
      invitationId: invitationId,
    );

    result.fold(
      (failure) => emit(RegistrationError(failure.message)),
      (registration) => emit(RegistrationSuccess(registration)),
    );
  }

  void reset() {
    emit(const RegistrationInitial());
  }
}
