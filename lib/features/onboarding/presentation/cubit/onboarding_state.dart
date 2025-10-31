part of 'onboarding_cubit.dart';

class OnboardingState extends Equatable {
  final int currentPage;

  const OnboardingState({required this.currentPage});

  bool get isLastPage => currentPage == 2;
  bool get isFirstPage => currentPage == 0;

  OnboardingState copyWith({int? currentPage}) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object?> get props => [currentPage];
}
