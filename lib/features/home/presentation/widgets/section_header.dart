import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';

/// Section header widget with optional action button
class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onActionPressed;
  final IconData? actionIcon;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionText,
    this.onActionPressed,
    this.actionIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Title
          Text(
            title,
            style: AppTextStyles.headingSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          // Action button
          if (actionText != null && onActionPressed != null)
            GestureDetector(
              onTap: onActionPressed,
              child: Row(
                children: [
                  Text(
                    actionText!,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (actionIcon != null) ...[
                    SizedBox(width: 4.w),
                    Icon(
                      actionIcon,
                      size: 16.w,
                      color: AppColors.primary,
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}
