import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/cubit/theme_cubit.dart';
import '../../../../core/theme/cubit/theme_state.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/modern_dialog.dart';
import '../../../auth/domain/usecases/logout_usecase.dart';
import '../../../../core/router/app_router.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool eventReminders = true;
  bool registrationNotifications = true;
  bool isAndroid12Plus = false;

  @override
  void initState() {
    super.initState();
    _checkAndroidVersion();
  }

  Future<void> _checkAndroidVersion() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      try {
        final deviceInfo = DeviceInfoPlugin();
        final androidInfo = await deviceInfo.androidInfo;
        setState(() {
          isAndroid12Plus = androidInfo.version.sdkInt >= 31; // Android 12 = API 31
        });
      } catch (e) {
        // If detection fails, assume false
        setState(() => isAndroid12Plus = false);
      }
    }
  }

  Future<void> _handleLogout(BuildContext context) async {
    final confirm = await showModernDialog<bool>(
      context: context,
      title: 'Logout',
      content: const Text('Are you sure you want to logout?'),
      useGlass: true,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.error,
          ),
          child: const Text('Logout'),
        ),
      ],
    );

    if (confirm == true) {
      await getIt<LogoutUseCase>()();
      if (mounted) context.go(AppRouter.login);
    }
  }

  String _getThemeLabel(ThemeState state) {
    if (state is ThemeLight) return 'Light';
    if (state is ThemeDark) return 'Dark';
    return 'System';
  }

  String _getCurrentThemeStatus(BuildContext context, ThemeState state) {
    if (state is ThemeSystem) {
      final brightness = MediaQuery.platformBrightnessOf(context);
      return brightness == Brightness.dark
          ? 'Currently using dark theme'
          : 'Currently using light theme';
    } else if (state is ThemeDark) {
      return 'Currently using dark theme';
    } else {
      return 'Currently using light theme';
    }
  }

  IconData _getCurrentThemeIcon(BuildContext context, ThemeState state) {
    if (state is ThemeSystem) {
      final brightness = MediaQuery.platformBrightnessOf(context);
      return brightness == Brightness.dark ? Icons.dark_mode : Icons.light_mode;
    } else if (state is ThemeDark) {
      return Icons.dark_mode;
    } else {
      return Icons.light_mode;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return ListView(
            padding: EdgeInsets.all(AppSpacing.lg),
            children: [
              // Notifications Section
              Text(
                'Notifications',
                style: AppTextStyles.headingSmall.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              GlassContainer(
                blur: 10,
                opacity: 0.05,
                padding: EdgeInsets.symmetric(
                  vertical: AppSpacing.xs,
                  horizontal: AppSpacing.sm,
                ),
                child: Column(
                  children: [
                    SwitchListTile(
                      value: eventReminders,
                      title: const Text('Event reminders'),
                      onChanged: (value) =>
                          setState(() => eventReminders = value),
                      activeTrackColor: AppColors.primary.withAlpha((0.5 * 255).round()),
                      thumbColor: WidgetStateProperty.resolveWith((states) =>
                          states.contains(WidgetState.selected)
                              ? AppColors.primary
                              : AppColors.textDisabled),
                    ),
                    Divider(color: AppColors.divider, height: 1),
                    SwitchListTile(
                      value: registrationNotifications,
                      title: const Text('Registration updates'),
                      onChanged: (value) =>
                          setState(() => registrationNotifications = value),
                      activeTrackColor: AppColors.primary.withAlpha((0.5 * 255).round()),
                      thumbColor: WidgetStateProperty.resolveWith((states) =>
                          states.contains(WidgetState.selected)
                              ? AppColors.primary
                              : AppColors.textDisabled),
                    ),
                  ],
                ),
              ),

              SizedBox(height: AppSpacing.xl),

              // Appearance Section
              Row(
                children: [
                  Icon(Icons.palette, color: AppColors.primary, size: 24.r),
                  SizedBox(width: AppSpacing.sm),
                  Text(
                    'Appearance',
                    style: AppTextStyles.headingSmall.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.sm),
              GlassContainer(
                blur: 10,
                opacity: 0.05,
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Choose your preferred theme',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: AppSpacing.md),

                    // Theme Segmented Control
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.border,
                          width: 1.w,
                        ),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      ),
                      child: Row(
                        children: [
                          _buildThemeOption(
                            context,
                            label: 'Light',
                            icon: Icons.light_mode,
                            isSelected: themeState is ThemeLight,
                            onTap: () => context.read<ThemeCubit>().setLightTheme(),
                            isFirst: true,
                          ),
                          _buildThemeOption(
                            context,
                            label: 'Dark',
                            icon: Icons.dark_mode,
                            isSelected: themeState is ThemeDark,
                            onTap: () => context.read<ThemeCubit>().setDarkTheme(),
                          ),
                          _buildThemeOption(
                            context,
                            label: 'System',
                            icon: Icons.settings_suggest,
                            isSelected: themeState is ThemeSystem,
                            onTap: () => context.read<ThemeCubit>().setSystemTheme(),
                            isLast: true,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: AppSpacing.md),

                    // Current Theme Status
                    Container(
                      padding: EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _getCurrentThemeIcon(context, themeState),
                            color: AppColors.primary,
                            size: 20.r,
                          ),
                          SizedBox(width: AppSpacing.sm),
                          Text(
                            _getCurrentThemeStatus(context, themeState),
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Dynamic Colors Toggle (Android 12+ only)
                    if (isAndroid12Plus) ...[
                      SizedBox(height: AppSpacing.md),
                      Divider(color: AppColors.divider, height: 1),
                      SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          Icon(
                            Icons.palette_outlined,
                            color: AppColors.secondary,
                            size: 20.r,
                          ),
                          SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Dynamic Colors',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  'Use colors from your wallpaper',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: context.read<ThemeCubit>().isDynamicColorsEnabled,
                            onChanged: (value) {
                              context.read<ThemeCubit>().toggleDynamicColors(value);
                            },
                            activeColor: AppColors.secondary,
                            activeTrackColor: AppColors.secondary.withAlpha((0.5 * 255).round()),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              SizedBox(height: AppSpacing.xl),

              // Account Section
              Row(
                children: [
                  Icon(Icons.account_circle, color: AppColors.primary, size: 24.r),
                  SizedBox(width: AppSpacing.sm),
                  Text(
                    'Account',
                    style: AppTextStyles.headingSmall.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.sm),
              GlassContainer(
                blur: 10,
                opacity: 0.05,
                padding: EdgeInsets.zero,
                child: ListTile(
                  leading: Icon(Icons.logout, color: AppColors.error),
                  title: Text(
                    'Logout',
                    style: TextStyle(
                      color: AppColors.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Icon(Icons.chevron_right, color: AppColors.error),
                  onTap: () => _handleLogout(context),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context, {
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withOpacity(0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.horizontal(
              left: isFirst ? Radius.circular(AppSpacing.radiusMd - 1.r) : Radius.zero,
              right: isLast ? Radius.circular(AppSpacing.radiusMd - 1.r) : Radius.zero,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                size: 24.r,
              ),
              SizedBox(height: 4.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isSelected) ...[
                    Icon(
                      Icons.check,
                      color: AppColors.primary,
                      size: 16.r,
                    ),
                    SizedBox(width: 4.w),
                  ],
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected ? AppColors.primary : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
