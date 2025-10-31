/// Size Configuration and Best Practices Guide
///
/// This file documents the responsive sizing strategy for the Eventify app.
/// All sizes should use flutter_screenutil for consistent scaling across devices.
///
/// DESIGN REFERENCE SIZE: iPhone 14 Pro (393×852)
/// All measurements scale proportionally from this baseline.
///
/// ============================================================================
/// QUICK REFERENCE GUIDE
library;
/// ============================================================================
///
/// 1. USE `.w` FOR WIDTHS
///    - Paddings (horizontal)
///    - Margins (horizontal)
///    - Container widths
///    - Example: `width: 100.w` or `padding: EdgeInsets.symmetric(horizontal: 16.w)`
///
/// 2. USE `.h` FOR HEIGHTS
///    - Paddings (vertical)
///    - Margins (vertical)
///    - Container heights
///    - Example: `height: 50.h` or `padding: EdgeInsets.symmetric(vertical: 12.h)`
///
/// 3. USE `.sp` FOR FONT SIZES
///    - All text sizes (fontSize property)
///    - Respects user's accessibility font size settings
///    - Example: `fontSize: 16.sp`
///
/// 4. USE `.r` FOR RADIUS & SQUARE ELEMENTS
///    - Border radius (circles, rounded corners)
///    - Icon sizes (when width == height)
///    - Button sizes (when width == height)
///    - Example: `borderRadius: BorderRadius.circular(12.r)` or `Icon(size: 24.r)`
///
/// ============================================================================
/// SPACING CONSTANTS (AppSpacing)
/// ============================================================================
///
/// Always use AppSpacing constants instead of hardcoded values:
///
/// CORRECT:
///   padding: EdgeInsets.all(AppSpacing.md)
///   SizedBox(height: AppSpacing.lg)
///
/// INCORRECT:
///   padding: EdgeInsets.all(16.0)  // ❌ Don't hardcode
///   SizedBox(height: 24.0)          // ❌ Don't hardcode
///
/// ============================================================================
/// REAL-WORLD EXAMPLES
/// ============================================================================
///
/// Example 1: Responsive Container
/// ```dart
/// Container(
///   width: 200.w,           // Scales with screen width
///   height: 100.h,          // Scales with screen height
///   padding: EdgeInsets.all(AppSpacing.md),  // Uses responsive spacing
///   decoration: BoxDecoration(
///     borderRadius: BorderRadius.circular(12.r),  // Responsive radius
///   ),
///   child: Icon(Icons.star, size: 24.r),  // Responsive icon
/// )
/// ```
///
/// Example 2: Responsive Text
/// ```dart
/// Text(
///   'Hello World',
///   style: TextStyle(
///     fontSize: 16.sp,      // Responsive font size
///     height: 1.5,          // Line height (ratio, not responsive)
///   ),
/// )
/// ```
///
/// Example 3: Responsive Padding (Mixed)
/// ```dart
/// Padding(
///   padding: EdgeInsets.symmetric(
///     horizontal: 20.w,     // Horizontal: use .w
///     vertical: 12.h,       // Vertical: use .h
///   ),
///   child: Text('Content'),
/// )
/// ```
///
/// ============================================================================
/// COMMON MISTAKES TO AVOID
/// ============================================================================
///
/// ❌ WRONG: Using .w for height
///    height: 50.w  // This scales with WIDTH, not height
///
/// ✅ CORRECT: Using .h for height
///    height: 50.h  // This scales with HEIGHT
///
/// ❌ WRONG: Using .sp for padding
///    padding: EdgeInsets.all(16.sp)  // .sp is only for text
///
/// ✅ CORRECT: Using AppSpacing or .w/.h for padding
///    padding: EdgeInsets.all(AppSpacing.md)
///
/// ❌ WRONG: Using .r for rectangular elements
///    Container(width: 100.r, height: 50.r)  // .r is for squares/circles
///
/// ✅ CORRECT: Using .w and .h for rectangles
///    Container(width: 100.w, height: 50.h)
///
/// ============================================================================
/// DEVICE BREAKPOINTS (For Future Tablet/Desktop Support)
/// ============================================================================
///
/// Use ScreenBreakpoints class for device-specific layouts:
///
/// ```dart
/// if (ScreenBreakpoints.isPhone(context)) {
///   // Phone layout
/// } else if (ScreenBreakpoints.isTablet(context)) {
///   // Tablet layout
/// } else {
///   // Desktop layout
/// }
/// ```
///
/// ============================================================================
/// TESTING RESPONSIVE UI
/// ============================================================================
///
/// Test on multiple screen sizes:
/// 1. Small phone: iPhone SE (375×667)
/// 2. Reference: iPhone 14 Pro (393×852)
/// 3. Large phone: iPhone 15 Pro Max (430×932)
/// 4. Tablet: iPad Air (820×1180)
/// 5. Android: Pixel 7 (412×915)
///
/// In Flutter DevTools:
/// - Use "Toggle Platform" to switch between iOS/Android
/// - Use "Device Frame" to visualize different devices
/// - Test with different font sizes (Accessibility)
///
/// ============================================================================

class SizeConfig {
  SizeConfig._();

  // This class is used only for documentation
  // Actual responsive utilities are in responsive_extensions.dart
}
