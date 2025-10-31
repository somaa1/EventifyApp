import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Extension methods for responsive sizing
///
/// Usage:
/// - Use `.w` for widths: `100.w` (responsive width)
/// - Use `.h` for heights: `50.h` (responsive height)
/// - Use `.sp` for font sizes: `16.sp` (responsive text size)
/// - Use `.r` for radius and square elements: `12.r` (responsive radius/size)

extension ResponsiveInt on int {
  /// Returns responsive width based on screen width
  /// Example: 100.w → scales based on actual device width
  double get w => ScreenUtil().setWidth(this);

  /// Returns responsive height based on screen height
  /// Example: 50.h → scales based on actual device height
  double get h => ScreenUtil().setHeight(this);

  /// Returns responsive font size with accessibility support
  /// Example: 16.sp → scales text while respecting user's font size settings
  double get sp => ScreenUtil().setSp(this);

  /// Returns responsive radius (minimum of width/height scaling)
  /// Use for border radius and square elements (icons, buttons)
  /// Example: 12.r → scales uniformly for circles and squares
  double get r => ScreenUtil().radius(this);
}

extension ResponsiveDouble on double {
  /// Returns responsive width based on screen width
  double get w => ScreenUtil().setWidth(this);

  /// Returns responsive height based on screen height
  double get h => ScreenUtil().setHeight(this);

  /// Returns responsive font size with accessibility support
  double get sp => ScreenUtil().setSp(this);

  /// Returns responsive radius (minimum of width/height scaling)
  double get r => ScreenUtil().radius(this);
}
