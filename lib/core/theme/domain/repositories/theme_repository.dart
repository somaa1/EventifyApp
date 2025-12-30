abstract class ThemeRepository {
  Future<String> getThemeMode();
  Future<void> saveThemeMode(String mode);
  Future<bool> getDynamicColorsEnabled();
  Future<void> saveDynamicColorsEnabled(bool enabled);
}
