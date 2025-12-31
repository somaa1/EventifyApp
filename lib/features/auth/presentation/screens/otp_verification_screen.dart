import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/di/injection.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/otp_input_field.dart';
import '../widgets/loading_button.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;

  const OtpVerificationScreen({
    super.key,
    required this.email,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  String _otp = '';
  int _remainingSeconds = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _remainingSeconds = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void _handleVerifyOtp(BuildContext context) {
    if (_otp.length == 6) {
      context.read<AuthBloc>().add(
            VerifyOtpRequested(
              email: widget.email,
              otp: _otp,
            ),
          );
    }
  }

  void _handleResendOtp(BuildContext context) {
    context.read<AuthBloc>().add(
          ResendOtpRequested(email: widget.email),
        );
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<AuthBloc>(),
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
              if (state is AuthAuthenticated) {
                // Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Verification successful!'),
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
              } else if (state is AuthOtpResent) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColors.success,
                  ),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: AppSpacing.xxl),

                    // Icon
                    Container(
                      width: 100.w,
                      height: 100.h,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.email_outlined,
                        size: 50.r,
                        color: AppColors.primary,
                      ),
                    )
                        .animate()
                        .scale(duration: 600.ms, curve: Curves.elasticOut),

                    SizedBox(height: AppSpacing.xl),

                    // Title
                    Text(
                      'Verify Your Email',
                      style: Theme.of(context).textTheme.displaySmall,
                      textAlign: TextAlign.center,
                    )
                        .animate()
                        .fadeIn(duration: 600.ms, delay: 200.ms)
                        .slideY(
                            begin: -0.3, end: 0, duration: 600.ms, delay: 200.ms),

                    SizedBox(height: AppSpacing.md),

                    // Description
                    Text(
                      'We sent a 6-digit code to',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                      textAlign: TextAlign.center,
                    )
                        .animate()
                        .fadeIn(duration: 600.ms, delay: 300.ms),

                    SizedBox(height: AppSpacing.xs),

                    Text(
                      widget.email,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.primary,
                          ),
                      textAlign: TextAlign.center,
                    )
                        .animate()
                        .fadeIn(duration: 600.ms, delay: 400.ms),

                    SizedBox(height: AppSpacing.xxl),

                    // OTP Input
                    OtpInputField(
                      onCompleted: (otp) {
                        setState(() {
                          _otp = otp;
                        });
                      },
                    )
                        .animate()
                        .fadeIn(duration: 600.ms, delay: 500.ms)
                        .slideY(begin: 0.3, end: 0, duration: 600.ms, delay: 500.ms),

                    SizedBox(height: AppSpacing.xl),

                    // Timer and Resend
                    if (_remainingSeconds > 0)
                      Text(
                        'Resend code in ${_remainingSeconds}s',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      )
                          .animate()
                          .fadeIn(duration: 600.ms, delay: 600.ms)
                    else
                      TextButton(
                        onPressed: () => _handleResendOtp(context),
                        child: const Text('Resend Code'),
                      )
                          .animate()
                          .fadeIn(duration: 600.ms),

                    SizedBox(height: AppSpacing.xl),

                    // Verify Button
                    LoadingButton(
                      text: 'Verify',
                      isLoading: isLoading,
                      onPressed: _otp.length == 6 ? () => _handleVerifyOtp(context) : null,
                    )
                        .animate()
                        .fadeIn(duration: 600.ms, delay: 700.ms)
                        .slideY(begin: 0.3, end: 0, duration: 600.ms, delay: 700.ms),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
