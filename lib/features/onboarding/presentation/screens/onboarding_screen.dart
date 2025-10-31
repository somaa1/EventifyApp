import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/router/app_router.dart';
import '../cubit/onboarding_cubit.dart';
import '../widgets/onboarding_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  final List<OnboardingPageData> pages = const [
    OnboardingPageData(
      title: 'Discover Events',
      description:
          'Find amazing events happening around you. From concerts to conferences, discover experiences that match your interests.',
      icon: Icons.explore_outlined,
      color: AppColors.primary,
    ),
    OnboardingPageData(
      title: 'Easy Registration',
      description:
          'Register for events with just a few taps. Get your QR ticket instantly and manage all your events in one place.',
      icon: Icons.qr_code_2_outlined,
      color: AppColors.secondary,
    ),
    OnboardingPageData(
      title: 'Join & Connect',
      description:
          'Connect with like-minded people, share experiences, and create unforgettable memories at every event.',
      icon: Icons.people_outline,
      color: Color(0xFFF59E0B),
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    await AppRouter.setFirstLaunchComplete();
    if (mounted) {
      context.go(AppRouter.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardingCubit(),
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<OnboardingCubit, OnboardingState>(
            builder: (context, state) {
              return Column(
                children: [
                  // Top Bar with Skip Button
                  Padding(
                    padding: EdgeInsets.all(AppSpacing.md),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (!state.isLastPage)
                          TextButton(
                            onPressed: () {
                              _pageController.animateToPage(
                                2,
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: Text(
                              'Skip',
                              style: AppTextStyles.button.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // PageView
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        context.read<OnboardingCubit>().pageChanged(index);
                      },
                      itemCount: pages.length,
                      itemBuilder: (context, index) {
                        return OnboardingPageWidget(
                          data: pages[index],
                          isActive: state.currentPage == index,
                        );
                      },
                    ),
                  ),

                  // Bottom Section with Indicator and Button
                  Padding(
                    padding: EdgeInsets.all(AppSpacing.xl),
                    child: Column(
                      children: [
                        // Page Indicator
                        AnimatedSmoothIndicator(
                          activeIndex: state.currentPage,
                          count: pages.length,
                          effect: ExpandingDotsEffect(
                            activeDotColor: AppColors.primary,
                            dotColor: AppColors.border,
                            dotHeight: 8.r,
                            dotWidth: 8.r,
                            expansionFactor: 4,
                            spacing: 8.w,
                          ),
                        ),

                        SizedBox(height: AppSpacing.xl),

                        // Navigation Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (state.isLastPage) {
                                _completeOnboarding();
                              } else {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeInOut,
                                );
                              }
                            },
                            child: Text(
                              state.isLastPage ? 'Get Started' : 'Next',
                            ),
                          ),
                        ),

                        if (!state.isLastPage) ...[
                          SizedBox(height: AppSpacing.md),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: state.isFirstPage
                                  ? null
                                  : () {
                                      _pageController.previousPage(
                                        duration:
                                            const Duration(milliseconds: 400),
                                        curve: Curves.easeInOut,
                                      );
                                    },
                              child: const Text('Back'),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
