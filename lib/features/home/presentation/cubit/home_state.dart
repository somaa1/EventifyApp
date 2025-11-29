import 'package:equatable/equatable.dart';
import '../../domain/entities/user_stats.dart';

/// States for HomeCubit
abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class HomeInitial extends HomeState {
  const HomeInitial();
}

/// Loading state
class HomeLoading extends HomeState {
  const HomeLoading();
}

/// Loaded state with user stats
class HomeLoaded extends HomeState {
  final UserStats stats;
  final String userName;
  final String userRole;
  final String userEmail;

  const HomeLoaded({
    required this.stats,
    required this.userName,
    required this.userRole,
    required this.userEmail,
  });

  @override
  List<Object?> get props => [stats, userName, userRole, userEmail];
}

/// Error state
class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
