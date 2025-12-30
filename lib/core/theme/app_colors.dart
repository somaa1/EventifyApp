import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static bool _isDark = false;

  static void setDarkMode(bool isDark) {
    _isDark = isDark;
  }

  static bool get isDarkMode => _isDark;

  // Primary Colors
  static Color get primary => _isDark ? const Color(0xFF818CF8) : const Color(0xFF6366F1); // Indigo
  static Color get primaryLight => _isDark ? const Color(0xFFA5B4FC) : const Color(0xFF818CF8);
  static Color get primaryDark => _isDark ? const Color(0xFF6366F1) : const Color(0xFF4F46E5);

  // Secondary Colors
  static Color get secondary => _isDark ? const Color(0xFF34D399) : const Color(0xFF10B981); // Green
  static Color get secondaryLight => _isDark ? const Color(0xFF6EE7B7) : const Color(0xFF34D399);
  static Color get secondaryDark => _isDark ? const Color(0xFF10B981) : const Color(0xFF059669);

  // Status Colors
  static Color get error => _isDark ? const Color(0xFFF87171) : const Color(0xFFEF4444); // Red
  static Color get warning => _isDark ? const Color(0xFFFBBF24) : const Color(0xFFF59E0B); // Amber
  static Color get success => _isDark ? const Color(0xFF34D399) : const Color(0xFF10B981); // Green
  static Color get info => _isDark ? const Color(0xFF60A5FA) : const Color(0xFF3B82F6); // Blue

  // Background Colors
  static Color get background => _isDark ? const Color(0xFF0F172A) : const Color(0xFFF9FAFB); // Slate 900 / Gray 50
  static Color get surface => _isDark ? const Color(0xFF1E293B) : const Color(0xFFFFFFFF); // Slate 800 / White
  static Color get surfaceVariant => _isDark ? const Color(0xFF334155) : const Color(0xFFF3F4F6); // Slate 700 / Gray 100
  static Color get surfaceElevated => _isDark ? const Color(0xFF475569) : const Color(0xFFFFFFFF); // Slate 600 / White

  // Text Colors
  static Color get textPrimary => _isDark ? const Color(0xFFF1F5F9) : const Color(0xFF111827); // Slate 100 / Gray 900
  static Color get textSecondary => _isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280); // Slate 400 / Gray 500
  static Color get textDisabled => _isDark ? const Color(0xFF64748B) : const Color(0xFF9CA3AF); // Slate 500 / Gray 400
  static const Color textOnPrimary = Color(0xFFFFFFFF); // White (same for both themes)

  // Border & Divider Colors
  static Color get border => _isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB); // Slate 700 / Gray 200
  static Color get borderColor => border; // Alias
  static Color get divider => _isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB); // Slate 700 / Gray 200

  // Glassmorphism Overlay Colors
  static Color get overlayLight => Colors.white.withOpacity(_isDark ? 0.05 : 0.1);
  static Color get overlayMedium => Colors.white.withOpacity(_isDark ? 0.1 : 0.15);
  static Color get overlayStrong => Colors.white.withOpacity(_isDark ? 0.15 : 0.2);

  // Gradient Colors
  static LinearGradient get primaryGradient => LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get backgroundGradient => _isDark
      ? const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        )
      : const LinearGradient(
          colors: [Color(0xFFF9FAFB), Color(0xFFFFFFFF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );

  static LinearGradient get cardGradient => _isDark
      ? LinearGradient(
          colors: [
            const Color(0xFF1E293B).withOpacity(0.8),
            const Color(0xFF334155).withOpacity(0.4),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
      : LinearGradient(
          colors: [
            const Color(0xFFFFFFFF).withOpacity(0.9),
            const Color(0xFFF3F4F6).withOpacity(0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );

  // Shimmer Colors (for Skeletonizer)
  static Color get shimmerBase => _isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB);
  static Color get shimmerHighlight => _isDark ? const Color(0xFF475569) : const Color(0xFFF3F4F6);
}
