import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_router.dart';
import '../../../core/di/injection.dart';
import '../../auth/data/datasources/auth_local_datasource.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(AppConstants.splashDuration);

    if (!mounted) return;

    // Check authentication status
    final authLocalDataSource = getIt<AuthLocalDataSource>();
    final isAuthenticated = await authLocalDataSource.isAuthenticated();

    if (isAuthenticated) {
      // User is logged in, navigate to home
      // TODO: Navigate to home screen when it's created
      if (!mounted) return;
      context.go(AppRouter.login); // Temporary - will change to home
    } else {
      // User is not logged in, check if first launch
      final isFirstLaunch = await AppRouter.isFirstLaunch();

      if (!mounted) return;
      if (isFirstLaunch) {
        context.go(AppRouter.onboarding);
      } else {
        context.go(AppRouter.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo Icon
              Container(
                width: 120.w,
                height: 120.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 20.r,
                      offset: Offset(0, 10.h),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.event,
                  size: 60.r,
                  color: AppColors.primary,
                ),
              )
                  .animate()
                  .scale(
                    duration: 600.ms,
                    curve: Curves.elasticOut,
                  )
                  .then(delay: 200.ms)
                  .shimmer(
                    duration: 1000.ms,
                    color: Colors.white.withValues(alpha: 0.3),
                  ),

              SizedBox(height: AppSpacing.xl),

              // App Name
              Text(
                AppConstants.appName,
                style: AppTextStyles.textTheme.displayMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              )
                  .animate()
                  .fadeIn(duration: 800.ms, delay: 300.ms)
                  .slideY(begin: 0.3, end: 0, duration: 800.ms, delay: 300.ms),

              SizedBox(height: AppSpacing.sm),

              // Tagline
              Text(
                'Discover, Connect, Celebrate',
                style: AppTextStyles.textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                  letterSpacing: 1.2,
                ),
              )
                  .animate()
                  .fadeIn(duration: 800.ms, delay: 500.ms)
                  .slideY(begin: 0.3, end: 0, duration: 800.ms, delay: 500.ms),

              SizedBox(height: AppSpacing.xxl * 2),

              // Loading Indicator
              SizedBox(
                width: 40.w,
                height: 40.h,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white.withValues(alpha: 0.8),
                  ),
                  strokeWidth: 3.w,
                ),
              )
                  .animate(
                    onPlay: (controller) => controller.repeat(),
                  )
                  .fadeIn(duration: 500.ms, delay: 700.ms),

              SizedBox(height: AppSpacing.xxl),

              // Version Number
              Text(
                'Version ${AppConstants.appVersion}',
                style: AppTextStyles.caption.copyWith(
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              )
                  .animate()
                  .fadeIn(duration: 800.ms, delay: 900.ms),
            ],
          ),
        ),
      ),
    );
  }
}
