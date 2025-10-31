import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Responsive spacing constants using flutter_screenutil
/// All values automatically scale based on screen size
/// Design reference: iPhone 14 Pro (393×852)
class AppSpacing {
  AppSpacing._();

  // Spacing Scale - uses .w for consistent horizontal/vertical spacing
  static double get xs => 4.w;
  static double get sm => 8.w;
  static double get md => 16.w;
  static double get lg => 24.w;
  static double get xl => 32.w;
  static double get xxl => 48.w;
  static double get xxxl => 64.w;

  // Border Radius - uses .r for uniform scaling
  static double get radiusXs => 4.r;
  static double get radiusSm => 8.r;
  static double get radiusMd => 12.r;
  static double get radiusLg => 16.r;
  static double get radiusXl => 24.r;
  static double get radiusFull => 9999.r;

  // Icon Sizes - uses .r for square elements
  static double get iconXs => 16.r;
  static double get iconSm => 20.r;
  static double get iconMd => 24.r;
  static double get iconLg => 32.r;
  static double get iconXl => 48.r;
  static double get iconXxl => 64.r;

  // Button Heights - uses .h for vertical sizing
  static double get buttonHeightSm => 36.h;
  static double get buttonHeightMd => 48.h;
  static double get buttonHeightLg => 56.h;

  // Screen Padding - uses responsive values
  static double get screenPaddingHorizontal => md;
  static double get screenPaddingVertical => md;
}
