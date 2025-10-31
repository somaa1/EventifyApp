class ApiConstants {
  ApiConstants._();

  // Base URL
  static const String baseUrl = 'https://imadapps.com/api/v1';

  // Timeout
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Auth Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resendOtp = '/auth/resend-otp';

  // User Endpoints
  static const String userMe = '/users/me';
  static const String users = '/users';

  // Event Endpoints
  static const String events = '/events';

  // Registration Endpoints
  static const String registrations = '/registrations';
  static const String registrationByToken = '/registrations/{token}';
  static const String registrationByInvitation = '/registrations/by-invitation/{token}';

  // Invitation Endpoints
  static const String sendInvitation = '/invitations/send';

  // Attendance Endpoints
  static const String confirmAttendance = '/attendance/confirm';
}
