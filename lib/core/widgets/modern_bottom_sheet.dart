import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'glass_container.dart';

Future<T?> showModernBottomSheet<T>({
  required BuildContext context,
  required Widget child,
  bool isDismissible = true,
  bool useGlass = true,
  bool enableDrag = true,
  double? height,
  String? title,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _ModernBottomSheet(
      child: child,
      useGlass: useGlass,
      height: height,
      title: title,
    ),
  );
}

class _ModernBottomSheet extends StatelessWidget {
  final Widget child;
  final bool useGlass;
  final double? height;
  final String? title;

  const _ModernBottomSheet({
    required this.child,
    this.useGlass = true,
    this.height,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: height ?? screenHeight * 0.9,
        ),
        child: useGlass
            ? GlassContainer(
                blur: 20,
                opacity: 0.2,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
                padding: EdgeInsets.zero,
                child: _buildContent(context),
              )
            : Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24.r),
                    topRight: Radius.circular(24.r),
                  ),
                ),
                child: _buildContent(context),
              ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Drag handle
        SizedBox(height: AppSpacing.sm),
        Container(
          width: 40.w,
          height: 4.h,
          decoration: BoxDecoration(
            color: AppColors.textDisabled.withOpacity(0.5),
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          ),
        ),
        SizedBox(height: AppSpacing.md),

        // Title (if provided)
        if (title != null) ...[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title!,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: AppColors.textSecondary),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          Divider(color: AppColors.divider),
        ],

        // Content
        Flexible(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: child,
          ),
        ),
      ],
    );
  }
}
