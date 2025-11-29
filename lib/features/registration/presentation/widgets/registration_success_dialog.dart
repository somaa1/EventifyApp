import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class RegistrationSuccessDialog extends StatelessWidget {
  final String eventTitle;
  final VoidCallback onViewTicket;

  const RegistrationSuccessDialog({
    super.key,
    required this.eventTitle,
    required this.onViewTicket,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success Icon with Animation
            Container(
              width: 80.r,
              height: 80.r,
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                size: 48.r,
                color: AppColors.success,
              ),
            )
                .animate()
                .scale(
                  duration: 400.ms,
                  curve: Curves.elasticOut,
                )
                .fadeIn(),

            SizedBox(height: AppSpacing.md),

            // Title
            Text(
              'Registration Successful!',
              style: AppTextStyles.headingMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.success,
              ),
              textAlign: TextAlign.center,
            )
                .animate()
                .fadeIn(delay: 200.ms)
                .slideY(begin: 0.3, end: 0),

            SizedBox(height: AppSpacing.sm),

            // Message
            Text(
              'You have successfully registered for',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            )
                .animate()
                .fadeIn(delay: 300.ms),

            SizedBox(height: 4.h),

            Text(
              eventTitle,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            )
                .animate()
                .fadeIn(delay: 400.ms),

            SizedBox(height: AppSpacing.lg),

            // View Ticket Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onViewTicket,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                icon: Icon(Icons.qr_code, size: 24.r, color: Colors.white),
                label: Text(
                  'View My Ticket',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
                .animate()
                .fadeIn(delay: 500.ms)
                .slideY(begin: 0.3, end: 0),
          ],
        ),
      ),
    );
  }
}
