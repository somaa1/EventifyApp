import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/di/injection.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/loading_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  void _handleLogin(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            LoginRequested(
              email: _emailController.text.trim(),
              password: _passwordController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<AuthBloc>(),
      child: Scaffold(
        body: SafeArea(
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthAuthenticated) {
                // Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Login successful!'),
                    backgroundColor: AppColors.success,
                    duration: const Duration(seconds: 1),
                  ),
                );
                // Navigate to home screen
                Future.delayed(const Duration(milliseconds: 500), () {
                  if (context.mounted) {
                    context.go(AppRouter.home);
                  }
                });
              } else if (state is AuthError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
            builder: (context, state) {
              final isLoading = state is AuthLoading;

              return SingleChildScrollView(
                padding: EdgeInsets.all(AppSpacing.xl),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: AppSpacing.xxl),

                      // Welcome Back Text
                      Text(
                        'Welcome Back',
                        style: Theme.of(context).textTheme.displaySmall,
                      )
                          .animate()
                          .fadeIn(duration: 600.ms)
                          .slideY(begin: -0.3, end: 0, duration: 600.ms),

                      SizedBox(height: AppSpacing.sm),

                      Text(
                        'Sign in to continue',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      )
                          .animate()
                          .fadeIn(duration: 600.ms, delay: 100.ms)
                          .slideY(
                              begin: -0.3, end: 0, duration: 600.ms, delay: 100.ms),

                      SizedBox(height: AppSpacing.xxl * 1.5),

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
                          .fadeIn(duration: 600.ms, delay: 200.ms)
                          .slideX(
                              begin: -0.2, end: 0, duration: 600.ms, delay: 200.ms),

                      SizedBox(height: AppSpacing.lg),

                      // Password Field
                      AuthTextField(
                        controller: _passwordController,
                        label: 'Password',
                        hint: 'Enter your password',
                        obscureText: _obscurePassword,
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        validator: _validatePassword,
                      )
                          .animate()
                          .fadeIn(duration: 600.ms, delay: 300.ms)
                          .slideX(
                              begin: -0.2, end: 0, duration: 600.ms, delay: 300.ms),

                      SizedBox(height: AppSpacing.md),

                      // Forgot Password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            context.push(AppRouter.forgotPassword);
                          },
                          child: const Text('Forgot Password?'),
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 600.ms, delay: 400.ms),

                      SizedBox(height: AppSpacing.xl),

                      // Login Button
                      LoadingButton(
                        text: 'Login',
                        isLoading: isLoading,
                        onPressed: () => _handleLogin(context),
                      )
                          .animate()
                          .fadeIn(duration: 600.ms, delay: 500.ms)
                          .slideY(begin: 0.3, end: 0, duration: 600.ms, delay: 500.ms),

                      SizedBox(height: AppSpacing.xl),

                      // Sign Up Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          TextButton(
                            onPressed: () {
                              context.push(AppRouter.register);
                            },
                            child: const Text('Sign Up'),
                          ),
                        ],
                      )
                          .animate()
                          .fadeIn(duration: 600.ms, delay: 600.ms),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
