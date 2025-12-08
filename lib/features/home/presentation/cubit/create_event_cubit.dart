import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/create_event_usecase.dart';
import '../../domain/usecases/update_event_usecase.dart';
import 'create_event_state.dart';

class CreateEventCubit extends Cubit<CreateEventState> {
  final CreateEventUseCase createEventUseCase;
  final UpdateEventUseCase updateEventUseCase;

  CreateEventCubit({
    required this.createEventUseCase,
    required this.updateEventUseCase,
  }) : super(const CreateEventInitial());

  Future<void> createEvent(Map<String, dynamic> data) async {
    emit(const CreateEventSubmitting());
    final result = await createEventUseCase(data);
    result.fold(
      (failure) => emit(CreateEventError(failure.message)),
      (event) => emit(CreateEventSuccess(event)),
    );
  }

  Future<void> updateEvent(String id, Map<String, dynamic> data) async {
    emit(const CreateEventSubmitting());
    final result = await updateEventUseCase(id, data);
    result.fold(
      (failure) => emit(CreateEventError(failure.message)),
      (event) => emit(CreateEventSuccess(event)),
    );
  }

  void reset() => emit(const CreateEventInitial());
}
