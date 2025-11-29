import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_user_stats_usecase.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import 'home_state.dart';

/// Cubit for managing home screen state
class HomeCubit extends Cubit<HomeState> {
  final GetUserStatsUseCase _getUserStatsUseCase;
  final AuthRepository _authRepository;

  HomeCubit({
    required GetUserStatsUseCase getUserStatsUseCase,
    required AuthRepository authRepository,
  })  : _getUserStatsUseCase = getUserStatsUseCase,
        _authRepository = authRepository,
        super(const HomeInitial());

  /// Load home screen data
  Future<void> loadHomeData() async {
    emit(const HomeLoading());

    try {
      // Get current user info from local storage
      final user = await _authRepository.getUserInfo();

      if (user == null) {
        emit(const HomeError('User not found. Please login again.'));
        return;
      }

      // Get user stats from API
      final statsResult = await _getUserStatsUseCase();

      statsResult.fold(
        (failure) {
          emit(HomeError(failure.message));
        },
        (stats) {
          emit(HomeLoaded(
            stats: stats,
            userName: user.name,
            userRole: user.role,
            userEmail: user.email,
          ));
        },
      );
    } catch (e) {
      emit(HomeError('Failed to load home data: ${e.toString()}'));
    }
  }

  /// Refresh home screen data
  Future<void> refresh() async {
    await loadHomeData();
  }
}
