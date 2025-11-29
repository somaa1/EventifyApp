import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_event_details_usecase.dart';
import 'event_details_state.dart';

class EventDetailsCubit extends Cubit<EventDetailsState> {
  final GetEventDetailsUseCase getEventDetailsUseCase;

  EventDetailsCubit({
    required this.getEventDetailsUseCase,
  }) : super(const EventDetailsInitial());

  Future<void> loadEventDetails(String eventId) async {
    emit(const EventDetailsLoading());

    final result = await getEventDetailsUseCase(eventId);

    result.fold(
      (failure) => emit(EventDetailsError(failure.message)),
      (event) => emit(EventDetailsLoaded(event)),
    );
  }

  Future<void> refreshEventDetails(String eventId) async {
    // Don't emit loading to avoid UI flicker during refresh
    final result = await getEventDetailsUseCase(eventId);

    result.fold(
      (failure) => emit(EventDetailsError(failure.message)),
      (event) => emit(EventDetailsLoaded(event)),
    );
  }
}
