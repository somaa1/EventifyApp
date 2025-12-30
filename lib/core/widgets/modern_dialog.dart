import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_shadows.dart';
import 'glass_container.dart';

Future<T?> showModernDialog<T>({
  required BuildContext context,
  required String title,
  required Widget content,
  List<Widget>? actions,
  bool useGlass = true,
  bool barrierDismissible = true,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) => _ModernDialog(
      title: title,
      content: content,
      actions: actions,
      useGlass: useGlass,
    ),
  );
}

class _ModernDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget>? actions;
  final bool useGlass;

  const _ModernDialog({
    required this.title,
    required this.content,
    this.actions,
    this.useGlass = true,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: _buildDialogContent(context),
    )
        .animate()
        .scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1, 1),
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        )
        .fadeIn(duration: const Duration(milliseconds: 200));
  }

  Widget _buildDialogContent(BuildContext context) {
    if (useGlass) {
      return GlassContainer(
        blur: 20,
        opacity: 0.2,
        borderRadius: BorderRadius.circular(20.r),
        padding: EdgeInsets.all(AppSpacing.lg),
        child: _buildContent(context),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: AppShadows.large(AppColors.isDarkMode),
      ),
      padding: EdgeInsets.all(AppSpacing.lg),
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          title,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: AppSpacing.md),

        // Content
        DefaultTextStyle(
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
          child: content,
        ),

        // Actions
        if (actions != null && actions!.isNotEmpty) ...[
          SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: actions!
                .map((action) => Padding(
                      padding: EdgeInsets.only(left: AppSpacing.sm),
                      child: action,
                    ))
                .toList(),
          ),
        ],
      ],
    );
  }
}
