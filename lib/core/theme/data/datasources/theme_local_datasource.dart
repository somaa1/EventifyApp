import 'package:shared_preferences/shared_preferences.dart';
import '../../theme_config.dart';

class ThemeLocalDataSource {
  final SharedPreferences _sharedPreferences;

  ThemeLocalDataSource(this._sharedPreferences);

  Future<String> getThemeMode() async {
    return _sharedPreferences.getString(ThemeConfig.themeModeKey) ??
           ThemeConfig.systemMode;
  }

  Future<void> saveThemeMode(String mode) async {
    await _sharedPreferences.setString(ThemeConfig.themeModeKey, mode);
  }

  Future<bool> getDynamicColorsEnabled() async {
    return _sharedPreferences.getBool(ThemeConfig.dynamicColorsEnabledKey) ??
           false;
  }

  Future<void> saveDynamicColorsEnabled(bool enabled) async {
    await _sharedPreferences.setBool(
      ThemeConfig.dynamicColorsEnabledKey,
      enabled,
    );
  }
}
