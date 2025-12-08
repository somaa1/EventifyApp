import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
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
  String themeMode = 'System';

  Future<void> _handleLogout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await getIt<LogoutUseCase>()();
      if (mounted) context.go(AppRouter.login);
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
      body: ListView(
        padding: EdgeInsets.all(AppSpacing.lg),
        children: [
          Text(
            'Notifications',
            style: AppTextStyles.headingSmall.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          SwitchListTile(
            value: eventReminders,
            title: const Text('Event reminders'),
            onChanged: (value) => setState(() => eventReminders = value),
            activeColor: AppColors.primary,
          ),
          SwitchListTile(
            value: registrationNotifications,
            title: const Text('Registration updates'),
            onChanged: (value) =>
                setState(() => registrationNotifications = value),
            activeColor: AppColors.primary,
          ),
          SizedBox(height: AppSpacing.lg),
          Text(
            'Appearance',
            style: AppTextStyles.headingSmall.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          ListTile(
            title: const Text('Theme'),
            subtitle: Text(themeMode),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              final selected = await showModalBottomSheet<String>(
                context: context,
                builder: (_) => _ThemePicker(current: themeMode),
              );
              if (selected != null) {
                setState(() => themeMode = selected);
              }
            },
          ),
          SizedBox(height: AppSpacing.lg),
          Text(
            'Account',
            style: AppTextStyles.headingSmall.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          ListTile(
            leading: Icon(Icons.logout, color: AppColors.error),
            title: Text(
              'Logout',
              style: TextStyle(color: AppColors.error),
            ),
            onTap: () => _handleLogout(context),
          ),
        ],
      ),
    );
  }
}

class _ThemePicker extends StatelessWidget {
  final String current;
  const _ThemePicker({required this.current});

  @override
  Widget build(BuildContext context) {
    final options = ['System', 'Light', 'Dark'];
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: options
            .map(
              (o) => RadioListTile<String>(
                value: o,
                groupValue: current,
                onChanged: (value) => Navigator.pop(context, value),
                title: Text(o),
              ),
            )
            .toList(),
      ),
    );
  }
}
