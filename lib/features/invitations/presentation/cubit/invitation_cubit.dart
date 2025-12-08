import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/send_invitation_usecase.dart';
import 'invitation_state.dart';

class InvitationCubit extends Cubit<InvitationState> {
  final SendInvitationUseCase sendInvitationUseCase;

  InvitationCubit({required this.sendInvitationUseCase})
      : super(const InvitationInitial());

  Future<void> sendInvitation({
    required int eventId,
    required String email,
  }) async {
    emit(const InvitationSending());
    final result = await sendInvitationUseCase(
      eventId: eventId,
      email: email,
    );
    result.fold(
      (failure) => emit(InvitationError(failure.message)),
      (invitation) => emit(InvitationSent(invitation)),
    );
  }

  void reset() => emit(const InvitationInitial());
}
