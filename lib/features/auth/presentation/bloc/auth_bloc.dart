import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import '../../domain/usecases/resend_otp_usecase.dart';
import '../../domain/usecases/check_auth_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final ResendOtpUseCase resendOtpUseCase;
  final CheckAuthUseCase checkAuthUseCase;
  final LogoutUseCase logoutUseCase;
  final AuthRepository authRepository;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.verifyOtpUseCase,
    required this.resendOtpUseCase,
    required this.checkAuthUseCase,
    required this.logoutUseCase,
    required this.authRepository,
  }) : super(const AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<VerifyOtpRequested>(_onVerifyOtpRequested);
    on<ResendOtpRequested>(_onResendOtpRequested);
    on<CheckAuthRequested>(_onCheckAuthRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final response = await loginUseCase(
        email: event.email,
        password: event.password,
      );

      if (response.isSuccess && response.token != null) {
        emit(AuthAuthenticated(
          token: response.token!,
          name: response.name,
          role: response.role,
        ));
      } else {
        emit(AuthError(message: response.message));
      }
    } on DioException catch (e) {
      emit(AuthError(message: _handleDioError(e)));
    } catch (e) {
      emit(AuthError(message: 'An unexpected error occurred. Please try again.'));
    }
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final response = await registerUseCase(
        name: event.name,
        email: event.email,
        password: event.password,
        role: event.role,
      );

      if (response.requiresOtpVerification) {
        emit(AuthOtpRequired(
          email: event.email,
          name: response.name,
          role: response.role,
          message: response.message,
        ));
      } else if (response.isSuccess && response.token != null) {
        emit(AuthAuthenticated(
          token: response.token!,
          name: response.name,
          role: response.role,
        ));
      } else {
        emit(AuthError(message: response.message));
      }
    } on DioException catch (e) {
      emit(AuthError(message: _handleDioError(e)));
    } catch (e) {
      emit(AuthError(message: 'An unexpected error occurred. Please try again.'));
    }
  }

  Future<void> _onVerifyOtpRequested(
    VerifyOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final response = await verifyOtpUseCase(
        email: event.email,
        otp: event.otp,
      );

      if (response.isSuccess && response.token != null) {
        emit(AuthAuthenticated(
          token: response.token!,
          name: response.name,
          role: response.role,
        ));
      } else {
        emit(AuthError(message: response.message));
      }
    } on DioException catch (e) {
      emit(AuthError(message: _handleDioError(e)));
    } catch (e) {
      emit(AuthError(message: 'An unexpected error occurred. Please try again.'));
    }
  }

  Future<void> _onResendOtpRequested(
    ResendOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final message = await resendOtpUseCase(email: event.email);
      emit(AuthOtpResent(message: message));
    } on DioException catch (e) {
      emit(AuthError(message: _handleDioError(e)));
    } catch (e) {
      emit(AuthError(message: 'Failed to resend OTP. Please try again.'));
    }
  }

  Future<void> _onCheckAuthRequested(
    CheckAuthRequested event,
    Emitter<AuthState> emit,
  ) async {
    final isAuth = await checkAuthUseCase();
    if (isAuth) {
      // Load saved user data from SharedPreferences
      final token = await authRepository.getAuthToken() ?? '';
      final user = await authRepository.getUserInfo();

      if (user != null) {
        // User is authenticated with valid data
        emit(AuthAuthenticated(
          token: token,
          name: user.name,
          role: user.role,
        ));
      } else {
        // User data not found, force re-login
        emit(const AuthUnauthenticated());
      }
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await logoutUseCase();
    emit(const AuthUnauthenticated());
  }

  String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return 'Connection timeout. Please check your internet and try again.';
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode == 401 || statusCode == 403) {
          return 'Invalid credentials. Please check your email and password.';
        } else if (statusCode == 400) {
          // Try to extract error message from response
          final data = error.response?.data;
          if (data is Map && data.containsKey('message')) {
            return data['message'].toString();
          }
          return 'Invalid request. Please check your input.';
        } else if (statusCode == 500) {
          return 'Server error. Please try again later.';
        }
        return 'An error occurred. Please try again.';
      case DioExceptionType.cancel:
        return 'Request cancelled.';
      case DioExceptionType.unknown:
        if (error.message?.contains('SocketException') == true) {
          return 'No internet connection. Please check your network.';
        }
        return 'An unexpected error occurred. Please try again.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}
