import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppShadows {
  AppShadows._();

  // Small elevation (cards at rest)
  static List<BoxShadow> small(bool isDark) => [
        BoxShadow(
          color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
          blurRadius: 10.r,
          offset: Offset(0, 2.h),
        ),
        BoxShadow(
          color: Colors.black.withOpacity(isDark ? 0.2 : 0.02),
          blurRadius: 20.r,
          offset: Offset(0, 4.h),
        ),
      ];

  // Medium elevation (hover states, raised cards)
  static List<BoxShadow> medium(bool isDark) => [
        BoxShadow(
          color: Colors.black.withOpacity(isDark ? 0.4 : 0.08),
          blurRadius: 20.r,
          offset: Offset(0, 4.h),
        ),
        BoxShadow(
          color: Colors.black.withOpacity(isDark ? 0.3 : 0.04),
          blurRadius: 40.r,
          offset: Offset(0, 8.h),
        ),
      ];

  // Large elevation (modals, dialogs)
  static List<BoxShadow> large(bool isDark) => [
        BoxShadow(
          color: Colors.black.withOpacity(isDark ? 0.5 : 0.12),
          blurRadius: 30.r,
          offset: Offset(0, 8.h),
        ),
        BoxShadow(
          color: Colors.black.withOpacity(isDark ? 0.4 : 0.08),
          blurRadius: 60.r,
          offset: Offset(0, 16.h),
        ),
      ];

  // Extra large elevation (floating elements)
  static List<BoxShadow> extraLarge(bool isDark) => [
        BoxShadow(
          color: Colors.black.withOpacity(isDark ? 0.6 : 0.15),
          blurRadius: 40.r,
          offset: Offset(0, 12.h),
        ),
        BoxShadow(
          color: Colors.black.withOpacity(isDark ? 0.5 : 0.10),
          blurRadius: 80.r,
          offset: Offset(0, 24.h),
        ),
      ];
}
