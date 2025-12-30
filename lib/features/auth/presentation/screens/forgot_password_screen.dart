import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/loading_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  void _handleResetPassword() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement forgot password functionality when backend endpoint is ready
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Password reset feature coming soon!'),
          backgroundColor: AppColors.info,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: AppSpacing.xxl),

                // Icon
                Container(
                  width: 80.w,
                  height: 80.h,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.lock_reset,
                    size: 40.r,
                    color: AppColors.primary,
                  ),
                )
                    .animate()
                    .scale(duration: 600.ms, curve: Curves.elasticOut),

                SizedBox(height: AppSpacing.xl),

                // Title
                Text(
                  'Forgot Password?',
                  style: Theme.of(context).textTheme.displaySmall,
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 200.ms)
                    .slideY(begin: -0.3, end: 0, duration: 600.ms, delay: 200.ms),

                SizedBox(height: AppSpacing.sm),

                Text(
                  "Don't worry! Enter your email and we'll send you a reset link.",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 300.ms),

                SizedBox(height: AppSpacing.xxl),

                // Email Field
                AuthTextField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'Enter your email',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email_outlined),
                  validator: _validateEmail,
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 400.ms)
                    .slideX(begin: -0.2, end: 0, duration: 600.ms, delay: 400.ms),

                SizedBox(height: AppSpacing.xl),

                // Reset Button
                LoadingButton(
                  text: 'Send Reset Link',
                  onPressed: _handleResetPassword,
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 500.ms)
                    .slideY(begin: 0.3, end: 0, duration: 600.ms, delay: 500.ms),

                SizedBox(height: AppSpacing.lg),

                // Back to Login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_back,
                      size: 16.r,
                      color: AppColors.primary,
                    ),
                    TextButton(
                      onPressed: () => context.pop(),
                      child: const Text('Back to Login'),
                    ),
                  ],
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 600.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
