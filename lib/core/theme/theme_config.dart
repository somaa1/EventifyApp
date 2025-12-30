class ThemeConfig {
  ThemeConfig._();

  // Storage keys
  static const String themeModeKey = 'theme_mode';
  static const String dynamicColorsEnabledKey = 'dynamic_colors_enabled';

  // Theme mode values
  static const String lightMode = 'light';
  static const String darkMode = 'dark';
  static const String systemMode = 'system';

  // Animation durations
  static const Duration themeTransitionDuration = Duration(milliseconds: 300);

  // Glassmorphism defaults
  static const double defaultBlur = 10.0;
  static const double defaultOpacity = 0.1;

  // Shadow defaults
  static const double smallShadowBlur = 10.0;
  static const double mediumShadowBlur = 20.0;
  static const double largeShadowBlur = 30.0;
}
