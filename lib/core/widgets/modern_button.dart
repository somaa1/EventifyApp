import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'glass_container.dart';

enum ModernButtonType { primary, secondary, text, danger }

class ModernButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final bool isLoading;
  final bool isGlass;
  final bool useGradient;
  final ModernButtonType type;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final IconData? icon;

  const ModernButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isLoading = false,
    this.isGlass = false,
    this.useGradient = false,
    this.type = ModernButtonType.primary,
    this.width,
    this.height,
    this.padding,
    this.icon,
  });

  @override
  State<ModernButton> createState() => _ModernButtonState();
}

class _ModernButtonState extends State<ModernButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    if (widget.isGlass) {
      return _buildGlassButton();
    }

    return _buildStandardButton();
  }

  Widget _buildStandardButton() {
    final bool isEnabled = widget.onPressed != null && !widget.isLoading;

    Widget buttonContent = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.icon != null && !widget.isLoading) ...[
          Icon(widget.icon, size: 20.r),
          SizedBox(width: 8.w),
        ],
        if (widget.isLoading)
          SizedBox(
            width: 20.r,
            height: 20.r,
            child: CircularProgressIndicator(
              strokeWidth: 2.w,
              valueColor: AlwaysStoppedAnimation<Color>(
                widget.type == ModernButtonType.primary
                    ? AppColors.textOnPrimary
                    : AppColors.primary,
              ),
            ),
          )
        else
          widget.child,
      ],
    );

    switch (widget.type) {
      case ModernButtonType.primary:
        return _buildElevatedButton(buttonContent, isEnabled);
      case ModernButtonType.secondary:
        return _buildOutlinedButton(buttonContent, isEnabled);
      case ModernButtonType.danger:
        return _buildDangerButton(buttonContent, isEnabled);
      case ModernButtonType.text:
        return _buildTextButton(buttonContent, isEnabled);
    }
  }

  Widget _buildElevatedButton(Widget content, bool isEnabled) {
    return SizedBox(
      width: widget.width ?? double.infinity,
      height: widget.height ?? AppSpacing.buttonHeightMd,
      child: ElevatedButton(
        onPressed: isEnabled ? widget.onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.useGradient ? null : AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          elevation: 0,
          padding: widget.padding ??
              EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
        ),
        child: widget.useGradient
            ? Ink(
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: Container(
                  alignment: Alignment.center,
                  child: content,
                ),
              )
            : content,
      ),
    )
        .animate(target: _isPressed ? 1 : 0)
        .scale(begin: const Offset(1, 1), end: const Offset(0.95, 0.95));
  }

  Widget _buildOutlinedButton(Widget content, bool isEnabled) {
    return SizedBox(
      width: widget.width ?? double.infinity,
      height: widget.height ?? AppSpacing.buttonHeightMd,
      child: OutlinedButton(
        onPressed: isEnabled ? widget.onPressed : null,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: BorderSide(color: AppColors.primary, width: 1.5.w),
          padding: widget.padding ??
              EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
        ),
        child: content,
      ),
    )
        .animate(target: _isPressed ? 1 : 0)
        .scale(begin: const Offset(1, 1), end: const Offset(0.95, 0.95));
  }

  Widget _buildDangerButton(Widget content, bool isEnabled) {
    return SizedBox(
      width: widget.width ?? double.infinity,
      height: widget.height ?? AppSpacing.buttonHeightMd,
      child: ElevatedButton(
        onPressed: isEnabled ? widget.onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.error,
          foregroundColor: AppColors.textOnPrimary,
          elevation: 0,
          padding: widget.padding ??
              EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
        ),
        child: content,
      ),
    )
        .animate(target: _isPressed ? 1 : 0)
        .scale(begin: const Offset(1, 1), end: const Offset(0.95, 0.95));
  }

  Widget _buildTextButton(Widget content, bool isEnabled) {
    return TextButton(
      onPressed: isEnabled ? widget.onPressed : null,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        padding: widget.padding ??
            EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
      ),
      child: content,
    );
  }

  Widget _buildGlassButton() {
    final bool isEnabled = widget.onPressed != null && !widget.isLoading;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        if (isEnabled) widget.onPressed?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: GlassContainer(
        blur: 15,
        opacity: 0.15,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        padding: widget.padding ??
            EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
        child: Center(
          child: widget.isLoading
              ? SizedBox(
                  width: 20.r,
                  height: 20.r,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.w,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                )
              : DefaultTextStyle(
                  style: AppTextStyles.button.copyWith(
                    color: AppColors.primary,
                  ),
                  child: widget.child,
                ),
        ),
      ),
    )
        .animate(target: _isPressed ? 1 : 0)
        .scale(begin: const Offset(1, 1), end: const Offset(0.95, 0.95));
  }
}
