import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

/// Responsive text styles using flutter_screenutil
/// All font sizes use .sp for automatic scaling with accessibility support
/// Design reference: iPhone 14 Pro (393×852)
class AppTextStyles {
  AppTextStyles._();

  static TextTheme textTheme = TextTheme(
    // Display Styles (Extra Large)
    displayLarge: GoogleFonts.poppins(
      fontSize: 32.sp,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary,
      height: 1.2,
    ),
    displayMedium: GoogleFonts.poppins(
      fontSize: 28.sp,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary,
      height: 1.2,
    ),
    displaySmall: GoogleFonts.poppins(
      fontSize: 24.sp,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary,
      height: 1.3,
    ),

    // Headline Styles
    headlineLarge: GoogleFonts.poppins(
      fontSize: 22.sp,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
      height: 1.3,
    ),
    headlineMedium: GoogleFonts.poppins(
      fontSize: 20.sp,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
      height: 1.3,
    ),
    headlineSmall: GoogleFonts.poppins(
      fontSize: 18.sp,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
      height: 1.4,
    ),

    // Title Styles
    titleLarge: GoogleFonts.poppins(
      fontSize: 18.sp,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
      height: 1.4,
    ),
    titleMedium: GoogleFonts.poppins(
      fontSize: 16.sp,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
      height: 1.4,
    ),
    titleSmall: GoogleFonts.poppins(
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
      height: 1.4,
    ),

    // Body Styles
    bodyLarge: GoogleFonts.inter(
      fontSize: 16.sp,
      fontWeight: FontWeight.normal,
      color: AppColors.textPrimary,
      height: 1.5,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: 14.sp,
      fontWeight: FontWeight.normal,
      color: AppColors.textPrimary,
      height: 1.5,
    ),
    bodySmall: GoogleFonts.inter(
      fontSize: 12.sp,
      fontWeight: FontWeight.normal,
      color: AppColors.textSecondary,
      height: 1.5,
    ),

    // Label Styles
    labelLarge: GoogleFonts.inter(
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimary,
      height: 1.4,
    ),
    labelMedium: GoogleFonts.inter(
      fontSize: 12.sp,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimary,
      height: 1.4,
    ),
    labelSmall: GoogleFonts.inter(
      fontSize: 11.sp,
      fontWeight: FontWeight.w500,
      color: AppColors.textSecondary,
      height: 1.4,
    ),
  );

  // Custom Text Styles
  static TextStyle button = GoogleFonts.poppins(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textOnPrimary,
    height: 1.2,
  );

  static TextStyle caption = GoogleFonts.inter(
    fontSize: 12.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  static TextStyle overline = GoogleFonts.inter(
    fontSize: 10.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.6,
    letterSpacing: 1.5,
  );

  // Convenient aliases for common use cases
  static TextStyle get headingLarge => textTheme.headlineLarge!;
  static TextStyle get headingMedium => textTheme.headlineMedium!;
  static TextStyle get headingSmall => textTheme.headlineSmall!;
  static TextStyle get bodyLarge => textTheme.bodyLarge!;
  static TextStyle get bodyMedium => textTheme.bodyMedium!;
  static TextStyle get bodySmall => textTheme.bodySmall!;
}
