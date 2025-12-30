import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final BorderRadius? borderRadius;
  final bool showBorder;
  final Gradient? gradient;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;

  const GlassContainer({
    super.key,
    required this.child,
    this.blur = 10.0,
    this.opacity = 0.1,
    this.borderRadius,
    this.showBorder = true,
    this.gradient,
    this.padding,
    this.margin,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final defaultBorderRadius = BorderRadius.circular(12.r);
    final effectiveBorderRadius = borderRadius ?? defaultBorderRadius;

    return Container(
      width: width,
      height: height,
      margin: margin,
      child: ClipRRect(
        borderRadius: effectiveBorderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: blur,
            sigmaY: blur,
          ),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              gradient: gradient ?? _defaultGradient,
              borderRadius: effectiveBorderRadius,
              border: showBorder
                  ? Border.all(
                      color: AppColors.isDarkMode
                          ? Colors.white.withOpacity(0.1)
                          : Colors.white.withOpacity(0.2),
                      width: 1.w,
                    )
                  : null,
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  Gradient get _defaultGradient {
    if (AppColors.isDarkMode) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.surface.withOpacity(opacity + 0.1),
          AppColors.surface.withOpacity(opacity),
        ],
      );
    } else {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(opacity + 0.2),
          Colors.white.withOpacity(opacity),
        ],
      );
    }
  }
}
