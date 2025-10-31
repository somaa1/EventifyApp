import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class OnboardingPageData {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const OnboardingPageData({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class OnboardingPageWidget extends StatelessWidget {
  final OnboardingPageData data;
  final bool isActive;

  const OnboardingPageWidget({
    super.key,
    required this.data,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),

          // Icon Container
          Container(
            width: 200.w,
            height: 200.h,
            decoration: BoxDecoration(
              color: data.color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Container(
                width: 150.w,
                height: 150.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      data.color,
                      data.color.withValues(alpha: 0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: data.color.withValues(alpha: 0.3),
                      blurRadius: 30.r,
                      offset: Offset(0, 15.h),
                    ),
                  ],
                ),
                child: Icon(
                  data.icon,
                  size: 70.r,
                  color: Colors.white,
                ),
              ),
            ),
          )
              .animate(
                target: isActive ? 1 : 0,
              )
              .scale(
                duration: 600.ms,
                curve: Curves.elasticOut,
              )
              .fadeIn(duration: 400.ms),

          SizedBox(height: AppSpacing.xxl),

          // Title
          Text(
            data.title,
            style: AppTextStyles.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          )
              .animate(
                target: isActive ? 1 : 0,
              )
              .fadeIn(duration: 500.ms, delay: 200.ms)
              .slideY(
                begin: 0.3,
                end: 0,
                duration: 500.ms,
                delay: 200.ms,
                curve: Curves.easeOut,
              ),

          SizedBox(height: AppSpacing.md),

          // Description
          Text(
            data.description,
            style: AppTextStyles.textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          )
              .animate(
                target: isActive ? 1 : 0,
              )
              .fadeIn(duration: 500.ms, delay: 400.ms)
              .slideY(
                begin: 0.3,
                end: 0,
                duration: 500.ms,
                delay: 400.ms,
                curve: Curves.easeOut,
              ),

          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
