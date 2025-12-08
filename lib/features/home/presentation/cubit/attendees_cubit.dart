import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_attendees_usecase.dart';
import 'attendees_state.dart';

class AttendeesCubit extends Cubit<AttendeesState> {
  final GetAttendeesUseCase getAttendeesUseCase;

  AttendeesCubit({required this.getAttendeesUseCase})
      : super(const AttendeesInitial());

  Future<void> load(String eventId) async {
    emit(const AttendeesLoading());
    final result = await getAttendeesUseCase(eventId);
    result.fold(
      (failure) => emit(AttendeesError(failure.message)),
      (attendees) => emit(AttendeesLoaded(attendees)),
    );
  }

  Future<void> refresh(String eventId) => load(eventId);
}
