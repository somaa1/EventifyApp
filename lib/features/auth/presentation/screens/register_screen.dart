import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/injection.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/loading_button.dart';
import '../widgets/role_selector_card.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String _selectedRole = AppConstants.roleAttendee;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
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
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  void _handleRegister(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            RegisterRequested(
              name: _nameController.text.trim(),
              email: _emailController.text.trim(),
              password: _passwordController.text,
              role: _selectedRole,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthBloc>(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: SafeArea(
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthOtpRequired) {
                // Navigate to OTP verification screen
                context.push(
                  '${AppRouter.otpVerification}?email=${state.email}',
                );
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
                      // Create Account Text
                      Text(
                        'Create Account',
                        style: Theme.of(context).textTheme.displaySmall,
                      )
                          .animate()
                          .fadeIn(duration: 600.ms)
                          .slideY(begin: -0.3, end: 0, duration: 600.ms),

                      SizedBox(height: AppSpacing.sm),

                      Text(
                        'Sign up to get started',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      )
                          .animate()
                          .fadeIn(duration: 600.ms, delay: 100.ms)
                          .slideY(
                              begin: -0.3, end: 0, duration: 600.ms, delay: 100.ms),

                      SizedBox(height: AppSpacing.xxl),

                      // Name Field
                      AuthTextField(
                        controller: _nameController,
                        label: 'Full Name',
                        hint: 'Enter your full name',
                        prefixIcon: const Icon(Icons.person_outline),
                        validator: _validateName,
                      )
                          .animate()
                          .fadeIn(duration: 600.ms, delay: 200.ms)
                          .slideX(
                              begin: -0.2, end: 0, duration: 600.ms, delay: 200.ms),

                      SizedBox(height: AppSpacing.lg),

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
                          .fadeIn(duration: 600.ms, delay: 300.ms)
                          .slideX(
                              begin: -0.2, end: 0, duration: 600.ms, delay: 300.ms),

                      SizedBox(height: AppSpacing.lg),

                      // Password Field
                      AuthTextField(
                        controller: _passwordController,
                        label: 'Password',
                        hint: 'Create a strong password',
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
                          .fadeIn(duration: 600.ms, delay: 400.ms)
                          .slideX(
                              begin: -0.2, end: 0, duration: 600.ms, delay: 400.ms),

                      SizedBox(height: AppSpacing.xl),

                      // Role Selection
                      Text(
                        'I am a...',
                        style: Theme.of(context).textTheme.titleMedium,
                      )
                          .animate()
                          .fadeIn(duration: 600.ms, delay: 500.ms),

                      SizedBox(height: AppSpacing.md),

                      RoleSelectorCard(
                        role: AppConstants.roleAttendee,
                        title: 'Attendee',
                        description: 'Discover and attend amazing events',
                        icon: Icons.person,
                        isSelected: _selectedRole == AppConstants.roleAttendee,
                        onTap: () {
                          setState(() {
                            _selectedRole = AppConstants.roleAttendee;
                          });
                        },
                      )
                          .animate()
                          .fadeIn(duration: 600.ms, delay: 550.ms)
                          .slideX(
                              begin: -0.2, end: 0, duration: 600.ms, delay: 550.ms),

                      SizedBox(height: AppSpacing.md),

                      RoleSelectorCard(
                        role: AppConstants.roleOrganizer,
                        title: 'Organizer',
                        description: 'Create and manage your own events',
                        icon: Icons.event,
                        isSelected: _selectedRole == AppConstants.roleOrganizer,
                        onTap: () {
                          setState(() {
                            _selectedRole = AppConstants.roleOrganizer;
                          });
                        },
                      )
                          .animate()
                          .fadeIn(duration: 600.ms, delay: 600.ms)
                          .slideX(
                              begin: -0.2, end: 0, duration: 600.ms, delay: 600.ms),

                      SizedBox(height: AppSpacing.xl),

                      // Register Button
                      LoadingButton(
                        text: 'Create Account',
                        isLoading: isLoading,
                        onPressed: () => _handleRegister(context),
                      )
                          .animate()
                          .fadeIn(duration: 600.ms, delay: 700.ms)
                          .slideY(begin: 0.3, end: 0, duration: 600.ms, delay: 700.ms),

                      SizedBox(height: AppSpacing.xl),

                      // Login Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          TextButton(
                            onPressed: () {
                              context.pop();
                            },
                            child: const Text('Log In'),
                          ),
                        ],
                      )
                          .animate()
                          .fadeIn(duration: 600.ms, delay: 800.ms),
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
