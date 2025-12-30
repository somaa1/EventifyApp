import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/di/injection.dart';
import '../constants/app_constants.dart';

// Auth screens
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/otp_verification_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';

// Onboarding & Splash
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';

// Home screens
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/home/presentation/screens/events_screen.dart';
import '../../features/home/presentation/screens/event_details_screen.dart';
import '../../features/home/presentation/screens/my_events_screen.dart';
import '../../features/home/presentation/screens/calendar_screen.dart';
import '../../features/home/presentation/screens/create_event_screen.dart';
import '../../features/home/presentation/screens/edit_event_screen.dart';
import '../../features/home/presentation/screens/event_management_screen.dart';
import '../../features/home/presentation/screens/attendee_list_screen.dart';
import '../../features/home/presentation/cubit/events_cubit.dart';
import '../../features/home/domain/entities/event.dart';

// Invitations
import '../../features/invitations/presentation/screens/send_invitation_screen.dart';

// Profile screens
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/profile/domain/entities/user_profile.dart';

// Settings
import '../../features/settings/presentation/screens/settings_screen.dart';

// Admin screens
import '../../features/admin/presentation/screens/admin_dashboard_screen.dart';
import '../../features/admin/presentation/screens/admin_events_screen.dart';

// Registration & Tickets
import '../../features/registration/presentation/screens/qr_ticket_screen.dart';

// Attendance
import '../../features/attendance/presentation/screens/qr_scanner_screen.dart';
import '../../features/attendance/presentation/screens/attendance_success_screen.dart';
import '../../features/attendance/presentation/screens/attendance_error_screen.dart';
import '../../features/attendance/domain/entities/attendance.dart';

// Custom page transition builders
class PageTransitions {
  // Smooth slide from right with fade (for navigation)
  static Widget slideFromRight(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      )),
      child: FadeTransition(
        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
          ),
        ),
        child: child,
      ),
    );
  }

  // Scale with fade (for modal-style screens)
  static Widget scaleWithFade(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.92, end: 1.0).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        ),
      ),
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }

  // Slide from bottom (for bottom sheets and modals)
  static Widget slideFromBottom(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.0, 1.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      )),
      child: FadeTransition(
        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
          ),
        ),
        child: child,
      ),
    );
  }

  // Smooth fade (for simple transitions)
  static Widget fade(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        ),
      ),
      child: child,
    );
  }
}

class AppRouter {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String otpVerification = '/otp-verification';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String events = '/events';
  static const String eventDetails = '/events/:id';
  static const String myEvents = '/my-events';
  static const String calendar = '/calendar';
  static const String ticket = '/ticket/:token';
  static const String qrScanner = '/qr-scanner';
  static const String attendanceSuccess = '/attendance/success';
  static const String attendanceError = '/attendance/error';
  static const String createEvent = '/create-event';
  static const String editEvent = '/edit-event/:id';
  static const String eventManagement = '/event-management';
  static const String sendInvitation = '/events/:id/invite';
  static const String attendeeList = '/events/:id/attendees';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String settings = '/settings';
  static const String adminDashboard = '/admin/dashboard';
  static const String adminEvents = '/admin/events';

  static GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        name: 'splash',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SplashScreen(),
          transitionsBuilder: PageTransitions.fade,
        ),
      ),
      GoRoute(
        path: onboarding,
        name: 'onboarding',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const OnboardingScreen(),
          transitionsBuilder: PageTransitions.slideFromRight,
        ),
      ),
      GoRoute(
        path: login,
        name: 'login',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const LoginScreen(),
          transitionsBuilder: PageTransitions.slideFromRight,
        ),
      ),
      GoRoute(
        path: register,
        name: 'register',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const RegisterScreen(),
          transitionsBuilder: PageTransitions.slideFromRight,
        ),
      ),
      GoRoute(
        path: otpVerification,
        name: 'otp-verification',
        pageBuilder: (context, state) {
          final email = state.uri.queryParameters['email'] ?? '';
          return CustomTransitionPage(
            key: state.pageKey,
            child: OtpVerificationScreen(email: email),
            transitionsBuilder: PageTransitions.slideFromRight,
          );
        },
      ),
      GoRoute(
        path: forgotPassword,
        name: 'forgot-password',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const ForgotPasswordScreen(),
          transitionsBuilder: PageTransitions.slideFromRight,
        ),
      ),
      GoRoute(
        path: home,
        name: 'home',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const HomeScreen(),
          transitionsBuilder: PageTransitions.fade,
        ),
      ),
      GoRoute(
        path: events,
        name: 'events',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: BlocProvider(
            create: (_) => getIt<EventsCubit>()..loadEvents(),
            child: const EventsScreen(),
          ),
          transitionsBuilder: PageTransitions.slideFromRight,
        ),
      ),
      GoRoute(
        path: eventDetails,
        name: 'event-details',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return CustomTransitionPage(
            key: state.pageKey,
            child: EventDetailsScreen(eventId: id),
            transitionsBuilder: PageTransitions.slideFromRight,
          );
        },
      ),
      GoRoute(
        path: myEvents,
        name: 'my-events',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const MyEventsScreen(),
          transitionsBuilder: PageTransitions.slideFromRight,
        ),
      ),
      GoRoute(
        path: calendar,
        name: 'calendar',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const CalendarScreen(),
          transitionsBuilder: PageTransitions.slideFromRight,
        ),
      ),
      GoRoute(
        path: ticket,
        name: 'ticket',
        pageBuilder: (context, state) {
          final token = state.pathParameters['token'] ?? '';
          return CustomTransitionPage(
            key: state.pageKey,
            child: QrTicketScreen(registrationToken: token),
            transitionsBuilder: PageTransitions.slideFromBottom,
          );
        },
      ),
      GoRoute(
        path: createEvent,
        name: 'create-event',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const CreateEventScreen(),
          transitionsBuilder: PageTransitions.scaleWithFade,
        ),
      ),
      GoRoute(
        path: editEvent,
        name: 'edit-event',
        pageBuilder: (context, state) {
          final event = state.extra as Event;
          return CustomTransitionPage(
            key: state.pageKey,
            child: EditEventScreen(event: event),
            transitionsBuilder: PageTransitions.scaleWithFade,
          );
        },
      ),
      GoRoute(
        path: eventManagement,
        name: 'event-management',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const EventManagementScreen(),
          transitionsBuilder: PageTransitions.slideFromRight,
        ),
      ),
      GoRoute(
        path: sendInvitation,
        name: 'send-invitation',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return CustomTransitionPage(
            key: state.pageKey,
            child: SendInvitationScreen(eventId: id),
            transitionsBuilder: PageTransitions.scaleWithFade,
          );
        },
      ),
      GoRoute(
        path: attendeeList,
        name: 'attendee-list',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return CustomTransitionPage(
            key: state.pageKey,
            child: AttendeeListScreen(eventId: id),
            transitionsBuilder: PageTransitions.slideFromRight,
          );
        },
      ),
      GoRoute(
        path: profile,
        name: 'profile',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const ProfileScreen(),
          transitionsBuilder: PageTransitions.fade,
        ),
      ),
      GoRoute(
        path: editProfile,
        name: 'edit-profile',
        pageBuilder: (context, state) {
          final profile = state.extra as UserProfile;
          return CustomTransitionPage(
            key: state.pageKey,
            child: EditProfileScreen(profile: profile),
            transitionsBuilder: PageTransitions.scaleWithFade,
          );
        },
      ),
      GoRoute(
        path: settings,
        name: 'settings',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SettingsScreen(),
          transitionsBuilder: PageTransitions.scaleWithFade,
        ),
      ),
      GoRoute(
        path: qrScanner,
        name: 'qr-scanner',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const QrScannerScreen(),
          transitionsBuilder: PageTransitions.slideFromBottom,
        ),
      ),
      GoRoute(
        path: attendanceSuccess,
        name: 'attendance-success',
        pageBuilder: (context, state) {
          final attendance = state.extra as Attendance;
          return CustomTransitionPage(
            key: state.pageKey,
            child: AttendanceSuccessScreen(attendance: attendance),
            transitionsBuilder: PageTransitions.scaleWithFade,
          );
        },
      ),
      GoRoute(
        path: adminDashboard,
        name: 'admin-dashboard',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const AdminDashboardScreen(),
          transitionsBuilder: PageTransitions.fade,
        ),
      ),
      GoRoute(
        path: adminEvents,
        name: 'admin-events',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const AdminEventsScreen(),
          transitionsBuilder: PageTransitions.slideFromRight,
        ),
      ),
      GoRoute(
        path: attendanceError,
        name: 'attendance-error',
        pageBuilder: (context, state) {
          final message = state.extra as String? ?? 'Unable to confirm attendance.';
          return CustomTransitionPage(
            key: state.pageKey,
            child: AttendanceErrorScreen(message: message),
            transitionsBuilder: PageTransitions.scaleWithFade,
          );
        },
      ),
    ],
  );

  static Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(AppConstants.keyIsFirstLaunch) ?? true;
  }

  static Future<void> setFirstLaunchComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keyIsFirstLaunch, false);
  }
}
