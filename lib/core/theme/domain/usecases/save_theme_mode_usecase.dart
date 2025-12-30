import '../repositories/theme_repository.dart';

class SaveThemeModeUseCase {
  final ThemeRepository _repository;

  SaveThemeModeUseCase(this._repository);

  Future<void> call(String mode) async {
    await _repository.saveThemeMode(mode);
  }
}
