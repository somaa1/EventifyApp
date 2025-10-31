import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Screen breakpoints for different device types
/// Useful for creating adaptive layouts (phones, tablets, desktops)
class ScreenBreakpoints {
  ScreenBreakpoints._();

  // Breakpoint values (in dp)
  static const double phoneMax = 600.0;
  static const double tabletMax = 1200.0;

  /// Check if current device is a phone (width < 600dp)
  static bool isPhone(BuildContext context) {
    return ScreenUtil().screenWidth < phoneMax;
  }

  /// Check if current device is a tablet (600dp <= width < 1200dp)
  static bool isTablet(BuildContext context) {
    return ScreenUtil().screenWidth >= phoneMax &&
        ScreenUtil().screenWidth < tabletMax;
  }

  /// Check if current device is a desktop (width >= 1200dp)
  static bool isDesktop(BuildContext context) {
    return ScreenUtil().screenWidth >= tabletMax;
  }

  /// Get current device type as a string
  static String getDeviceType(BuildContext context) {
    if (isPhone(context)) return 'Phone';
    if (isTablet(context)) return 'Tablet';
    return 'Desktop';
  }

  /// Check if screen is in portrait orientation
  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  /// Check if screen is in landscape orientation
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  /// Get responsive padding based on device type
  /// Useful for larger padding on tablets/desktops
  static double getResponsivePadding(BuildContext context) {
    if (isPhone(context)) return 16.0;
    if (isTablet(context)) return 24.0;
    return 32.0;
  }

  /// Get responsive max width for content (prevents overly wide content on tablets/desktops)
  static double getMaxContentWidth(BuildContext context) {
    if (isPhone(context)) return double.infinity;
    if (isTablet(context)) return 600.0;
    return 800.0;
  }
}
