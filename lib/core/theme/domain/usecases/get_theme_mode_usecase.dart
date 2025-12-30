import '../repositories/theme_repository.dart';

class GetThemeModeUseCase {
  final ThemeRepository _repository;

  GetThemeModeUseCase(this._repository);

  Future<String> call() async {
    return await _repository.getThemeMode();
  }
}
