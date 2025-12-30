import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

class ModernTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool useGlass;
  final int? maxLines;
  final bool enabled;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;

  const ModernTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.useGlass = false,
    this.maxLines = 1,
    this.enabled = true,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  @override
  State<ModernTextField> createState() => _ModernTextFieldState();
}

class _ModernTextFieldState extends State<ModernTextField> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) {
        setState(() => _isFocused = hasFocus);
      },
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.obscureText,
        keyboardType: widget.keyboardType,
        validator: widget.validator,
        onChanged: widget.onChanged,
        maxLines: widget.maxLines,
        enabled: widget.enabled,
        textInputAction: widget.textInputAction,
        onFieldSubmitted: widget.onFieldSubmitted,
        style: AppTextStyles.textTheme.bodyMedium?.copyWith(
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hint,
          prefixIcon: widget.prefixIcon != null
              ? Padding(
                  padding: EdgeInsets.only(left: AppSpacing.sm, right: AppSpacing.xs),
                  child: widget.prefixIcon,
                )
              : null,
          suffixIcon: widget.suffixIcon,
          filled: true,
          fillColor: widget.useGlass
              ? AppColors.surfaceVariant.withOpacity(0.5)
              : AppColors.surfaceVariant,
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            borderSide: BorderSide(
              color: AppColors.border,
              width: 1.w,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            borderSide: BorderSide(
              color: AppColors.border,
              width: 1.w,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            borderSide: BorderSide(
              color: AppColors.primary,
              width: 2.w,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            borderSide: BorderSide(
              color: AppColors.error,
              width: 1.w,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            borderSide: BorderSide(
              color: AppColors.error,
              width: 2.w,
            ),
          ),
          labelStyle: AppTextStyles.textTheme.bodyMedium?.copyWith(
            color: _isFocused ? AppColors.primary : AppColors.textSecondary,
          ),
          hintStyle: AppTextStyles.textTheme.bodyMedium?.copyWith(
            color: AppColors.textDisabled,
          ),
          errorStyle: AppTextStyles.textTheme.bodySmall?.copyWith(
            color: AppColors.error,
          ),
        ),
      ),
    );
  }
}
