import '../../domain/repositories/theme_repository.dart';
import '../datasources/theme_local_datasource.dart';

class ThemeRepositoryImpl implements ThemeRepository {
  final ThemeLocalDataSource _localDataSource;

  ThemeRepositoryImpl(this._localDataSource);

  @override
  Future<String> getThemeMode() async {
    return await _localDataSource.getThemeMode();
  }

  @override
  Future<void> saveThemeMode(String mode) async {
    await _localDataSource.saveThemeMode(mode);
  }

  @override
  Future<bool> getDynamicColorsEnabled() async {
    return await _localDataSource.getDynamicColorsEnabled();
  }

  @override
  Future<void> saveDynamicColorsEnabled(bool enabled) async {
    await _localDataSource.saveDynamicColorsEnabled(enabled);
  }
}
