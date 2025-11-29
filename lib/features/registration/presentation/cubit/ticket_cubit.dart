import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_registration_by_token_usecase.dart';
import '../../../home/domain/usecases/get_event_details_usecase.dart';
import 'ticket_state.dart';

class TicketCubit extends Cubit<TicketState> {
  final GetRegistrationByTokenUseCase _getRegistrationByTokenUseCase;
  final GetEventDetailsUseCase _getEventDetailsUseCase;

  TicketCubit({
    required GetRegistrationByTokenUseCase getRegistrationByTokenUseCase,
    required GetEventDetailsUseCase getEventDetailsUseCase,
  })  : _getRegistrationByTokenUseCase = getRegistrationByTokenUseCase,
        _getEventDetailsUseCase = getEventDetailsUseCase,
        super(const TicketInitial());

  Future<void> loadTicket(String registrationToken) async {
    emit(const TicketLoading());

    try {
      // First, get the registration
      final registrationResult = await _getRegistrationByTokenUseCase(registrationToken);

      await registrationResult.fold(
        (failure) async {
          emit(TicketError(failure.message));
        },
        (registration) async {
          // Then, get the event details
          final eventResult = await _getEventDetailsUseCase(registration.eventId.toString());

          eventResult.fold(
            (failure) {
              emit(TicketError(failure.message));
            },
            (event) {
              emit(TicketLoaded(
                registration: registration,
                event: event,
              ));
            },
          );
        },
      );
    } catch (e) {
      emit(TicketError('Failed to load ticket: ${e.toString()}'));
    }
  }

  Future<void> refreshTicket(String registrationToken) async {
    await loadTicket(registrationToken);
  }
}
