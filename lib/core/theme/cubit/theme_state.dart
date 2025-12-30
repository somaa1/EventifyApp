import 'package:equatable/equatable.dart';

abstract class ThemeState extends Equatable {
  const ThemeState();

  @override
  List<Object?> get props => [];
}

class ThemeInitial extends ThemeState {
  const ThemeInitial();
}

class ThemeLight extends ThemeState {
  const ThemeLight();
}

class ThemeDark extends ThemeState {
  const ThemeDark();
}

class ThemeSystem extends ThemeState {
  const ThemeSystem();
}
