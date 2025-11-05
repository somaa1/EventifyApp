import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/di/injection.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _handleLogout(BuildContext context) {
    context.read<AuthBloc>().add(LogoutRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthBloc>(),
      child: Scaffold(
        body: SafeArea(
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthUnauthenticated) {
                // Navigate to login after logout
                context.go(AppRouter.login);
              }
            },
            builder: (context, state) {
              // Get user data from authenticated state
              String userName = 'User';
              String userRole = 'ATTENDEE';

              if (state is AuthAuthenticated) {
                userName = state.name;
                userRole = state.role;
              }

              return SingleChildScrollView(
                padding: EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: AppSpacing.lg),

                    // Welcome Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome Back,',
                                style: AppTextStyles.textTheme.bodyLarge?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              )
                                  .animate()
                                  .fadeIn(duration: 600.ms)
                                  .slideY(begin: -0.3, end: 0, duration: 600.ms),

                              SizedBox(height: 4.h),

                              Text(
                                userName,
                                style: AppTextStyles.textTheme.displaySmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              )
                                  .animate()
                                  .fadeIn(duration: 600.ms, delay: 100.ms)
                                  .slideY(begin: -0.3, end: 0, duration: 600.ms, delay: 100.ms),
                            ],
                          ),
                        ),

                        // Logout Button
                        IconButton(
                          onPressed: () => _handleLogout(context),
                          icon: Icon(
                            Icons.logout,
                            size: AppSpacing.iconMd,
                            color: AppColors.error,
                          ),
                        )
                            .animate()
                            .fadeIn(duration: 600.ms, delay: 200.ms)
                            .scale(duration: 600.ms, delay: 200.ms),
                      ],
                    ),

                    SizedBox(height: AppSpacing.md),

                    // Role Badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: userRole == 'ORGANIZER'
                            ? AppColors.secondary.withValues(alpha: 0.1)
                            : AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                        border: Border.all(
                          color: userRole == 'ORGANIZER'
                              ? AppColors.secondary
                              : AppColors.primary,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            userRole == 'ORGANIZER' ? Icons.event : Icons.person,
                            size: 16.r,
                            color: userRole == 'ORGANIZER'
                                ? AppColors.secondary
                                : AppColors.primary,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            userRole,
                            style: AppTextStyles.textTheme.labelMedium?.copyWith(
                              color: userRole == 'ORGANIZER'
                                  ? AppColors.secondary
                                  : AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 600.ms, delay: 300.ms)
                        .slideX(begin: -0.2, end: 0, duration: 600.ms, delay: 300.ms),

                    SizedBox(height: AppSpacing.xxl),

                    // Coming Soon Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(AppSpacing.xl),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 20.r,
                            offset: Offset(0, 10.h),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.rocket_launch,
                            size: 60.r,
                            color: Colors.white,
                          ),

                          SizedBox(height: AppSpacing.md),

                          Text(
                            'More Features Coming Soon!',
                            style: AppTextStyles.textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          SizedBox(height: AppSpacing.sm),

                          Text(
                            'We\'re building amazing features for you.\nStay tuned!',
                            style: AppTextStyles.textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 800.ms, delay: 400.ms)
                        .scale(duration: 800.ms, delay: 400.ms, curve: Curves.elasticOut),

                    SizedBox(height: AppSpacing.xxl),

                    // Quick Info Cards
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoCard(
                            icon: Icons.event_available,
                            title: 'Events',
                            subtitle: 'Coming Soon',
                            color: AppColors.primary,
                            delay: 500,
                          ),
                        ),
                        SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: _buildInfoCard(
                            icon: Icons.qr_code_scanner,
                            title: 'Scan QR',
                            subtitle: 'Coming Soon',
                            color: AppColors.secondary,
                            delay: 600,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: AppSpacing.md),

                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoCard(
                            icon: Icons.person,
                            title: 'Profile',
                            subtitle: 'Coming Soon',
                            color: AppColors.warning,
                            delay: 700,
                          ),
                        ),
                        SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: _buildInfoCard(
                            icon: Icons.settings,
                            title: 'Settings',
                            subtitle: 'Coming Soon',
                            color: AppColors.info,
                            delay: 800,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: AppSpacing.xxl),

                    // Logout Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => _handleLogout(context),
                        icon: Icon(Icons.logout, size: 20.r),
                        label: const Text('Logout'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.error,
                          side: BorderSide(color: AppColors.error, width: 1.5),
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 600.ms, delay: 900.ms)
                        .slideY(begin: 0.3, end: 0, duration: 600.ms, delay: 900.ms),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required int delay,
  }) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(
          color: AppColors.border,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 24.r,
              color: color,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            title,
            style: AppTextStyles.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          Text(
            subtitle,
            style: AppTextStyles.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms, delay: delay.ms)
        .slideY(begin: 0.3, end: 0, duration: 600.ms, delay: delay.ms);
  }
}
