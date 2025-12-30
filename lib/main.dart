import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/cubit/theme_cubit.dart';
import 'core/theme/cubit/theme_state.dart';
import 'core/router/app_router.dart';
import 'core/di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize dependencies
  await initializeDependencies();

  runApp(const EventifyApp());
}

class EventifyApp extends StatelessWidget {
  const EventifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ThemeCubit>()..loadTheme(),
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          // Update AppColors based on theme state
          final bool isDark = state is ThemeDark ||
                              (state is ThemeSystem && MediaQuery.platformBrightnessOf(context) == Brightness.dark);
          AppColors.setDarkMode(isDark);

          // Determine theme mode
          final ThemeMode themeMode = state is ThemeLight
              ? ThemeMode.light
              : state is ThemeDark
                  ? ThemeMode.dark
                  : ThemeMode.system;

          // Update system UI overlay style
          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
              statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
              systemNavigationBarColor: isDark ? AppColors.surface : AppColors.surface,
              systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
            ),
          );

          return ScreenUtilInit(
            // Design reference size: iPhone 14 Pro (393×852)
            designSize: const Size(393, 852),
            // Minimum text adapt for accessibility
            minTextAdapt: true,
            // Split screen mode for tablets and foldables
            splitScreenMode: true,
            // Rebuild UI when screen size changes
            builder: (context, child) {
              return DynamicColorBuilder(
                builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
                  // Check if dynamic colors are enabled in cubit state
                  final dynamicColorsEnabled = context.read<ThemeCubit>().isDynamicColorsEnabled;

                  // Use dynamic colors if enabled and available (Android 12+)
                  final bool useDynamicColors = dynamicColorsEnabled &&
                                                lightDynamic != null &&
                                                darkDynamic != null;

                  return MaterialApp.router(
                    title: 'Eventify',
                    debugShowCheckedModeBanner: false,
                    theme: useDynamicColors
                        ? AppTheme.lightTheme.copyWith(colorScheme: lightDynamic)
                        : AppTheme.lightTheme,
                    darkTheme: useDynamicColors
                        ? AppTheme.darkTheme.copyWith(colorScheme: darkDynamic)
                        : AppTheme.darkTheme,
                    themeMode: themeMode,
                    routerConfig: AppRouter.router,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
