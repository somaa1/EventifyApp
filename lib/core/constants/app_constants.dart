class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Eventify';
  static const String appVersion = '1.0.0';

  // Storage Keys
  static const String keyToken = 'auth_token';
  static const String keyUserRole = 'user_role';
  static const String keyUserName = 'user_name';
  static const String keyUserEmail = 'user_email';
  static const String keyIsFirstLaunch = 'is_first_launch';
  static const String keyThemeMode = 'theme_mode';

  // Animation Durations
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration splashDuration = Duration(seconds: 2);
  static const Duration onboardingTransition = Duration(milliseconds: 400);

  // Onboarding
  static const int onboardingPageCount = 3;

  // Pagination
  static const int defaultPageSize = 20;

  // User Roles
  static const String roleAttendee = 'ATTENDEE';
  static const String roleOrganizer = 'ORGANIZER';
  static const String roleAdmin = 'ADMIN';

  // Event Types
  static const String eventTypePublic = 'PUBLIC';
  static const String eventTypePrivate = 'PRIVATE';

  // QR Code
  static const double qrCodeSize = 250.0;

  // Image Sizes
  static const double avatarSizeSmall = 40.0;
  static const double avatarSizeMedium = 60.0;
  static const double avatarSizeLarge = 100.0;
}
