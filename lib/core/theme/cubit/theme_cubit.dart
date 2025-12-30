import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/repositories/theme_repository.dart';
import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final ThemeRepository _themeRepository;
  bool _isDynamicColorsEnabled = false;

  ThemeCubit(this._themeRepository) : super(const ThemeInitial());

  bool get isDynamicColorsEnabled => _isDynamicColorsEnabled;

  Future<void> loadTheme() async {
    final themeMode = await _themeRepository.getThemeMode();
    _isDynamicColorsEnabled = await _themeRepository.getDynamicColorsEnabled();

    switch (themeMode) {
      case 'light':
        emit(const ThemeLight());
        break;
      case 'dark':
        emit(const ThemeDark());
        break;
      case 'system':
        emit(const ThemeSystem());
        break;
      default:
        emit(const ThemeSystem()); // Default to system
    }
  }

  Future<void> setLightTheme() async {
    await _themeRepository.saveThemeMode('light');
    emit(const ThemeLight());
  }

  Future<void> setDarkTheme() async {
    await _themeRepository.saveThemeMode('dark');
    emit(const ThemeDark());
  }

  Future<void> setSystemTheme() async {
    await _themeRepository.saveThemeMode('system');
    emit(const ThemeSystem());
  }

  Future<void> toggleDynamicColors(bool enabled) async {
    _isDynamicColorsEnabled = enabled;
    await _themeRepository.saveDynamicColorsEnabled(enabled);
    // Re-emit current state to trigger rebuild
    final currentState = state;
    if (currentState is ThemeLight) {
      emit(const ThemeLight());
    } else if (currentState is ThemeDark) {
      emit(const ThemeDark());
    } else if (currentState is ThemeSystem) {
      emit(const ThemeSystem());
    }
  }
}
