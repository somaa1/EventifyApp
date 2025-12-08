import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../constants/api_constants.dart';
import '../network/auth_interceptor.dart';
import '../../features/auth/data/datasources/auth_api_client.dart';
import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/domain/usecases/verify_otp_usecase.dart';
import '../../features/auth/domain/usecases/resend_otp_usecase.dart';
import '../../features/auth/domain/usecases/check_auth_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/home/data/datasources/event_api_client.dart';
import '../../features/home/data/datasources/user_api_client.dart';
import '../../features/home/data/repositories/event_repository_impl.dart';
import '../../features/home/data/repositories/user_repository_impl.dart';
import '../../features/home/domain/repositories/event_repository.dart';
import '../../features/home/domain/repositories/user_repository.dart';
import '../../features/home/domain/usecases/get_events_usecase.dart';
import '../../features/home/domain/usecases/get_user_stats_usecase.dart';
import '../../features/home/domain/usecases/get_event_details_usecase.dart';
import '../../features/home/domain/usecases/get_registered_events_usecase.dart';
import '../../features/home/domain/usecases/get_my_events_usecase.dart';
import '../../features/home/domain/usecases/create_event_usecase.dart';
import '../../features/home/domain/usecases/update_event_usecase.dart';
import '../../features/home/domain/usecases/delete_event_usecase.dart';
import '../../features/home/domain/usecases/get_attendees_usecase.dart';
import '../../features/profile/domain/usecases/get_profile_usecase.dart';
import '../../features/profile/domain/usecases/update_profile_usecase.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';
import '../../features/home/presentation/cubit/events_cubit.dart';
import '../../features/home/presentation/cubit/event_details_cubit.dart';
import '../../features/home/presentation/cubit/my_events_cubit.dart';
import '../../features/home/presentation/cubit/calendar_cubit.dart';
import '../../features/home/presentation/cubit/create_event_cubit.dart';
import '../../features/home/presentation/cubit/event_management_cubit.dart';
import '../../features/home/presentation/cubit/attendees_cubit.dart';
import '../../features/profile/presentation/cubit/profile_cubit.dart';
import '../../features/registration/data/datasources/registration_api_client.dart';
import '../../features/registration/data/repositories/registration_repository_impl.dart';
import '../../features/registration/domain/repositories/registration_repository.dart';
import '../../features/registration/domain/usecases/register_for_event_usecase.dart';
import '../../features/registration/domain/usecases/get_registration_by_token_usecase.dart';
import '../../features/registration/presentation/cubit/registration_cubit.dart';
import '../../features/registration/presentation/cubit/ticket_cubit.dart';
import '../../features/attendance/data/datasources/attendance_api_client.dart';
import '../../features/attendance/data/repositories/attendance_repository_impl.dart';
import '../../features/attendance/domain/repositories/attendance_repository.dart';
import '../../features/attendance/domain/usecases/confirm_attendance_usecase.dart';
import '../../features/attendance/presentation/cubit/attendance_cubit.dart';
import '../../features/invitations/data/datasources/invitation_api_client.dart';
import '../../features/invitations/data/repositories/invitation_repository_impl.dart';
import '../../features/invitations/domain/repositories/invitation_repository.dart';
import '../../features/invitations/domain/usecases/send_invitation_usecase.dart';
import '../../features/invitations/presentation/cubit/invitation_cubit.dart';

final getIt = GetIt.instance;

Future<void> initializeDependencies() async {
  // External Dependencies
  getIt.registerSingletonAsync<SharedPreferences>(
    () => SharedPreferences.getInstance(),
  );

  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      ),
    ),
  );

  await getIt.allReady();

  // Auth Feature - MUST be registered FIRST
  // because Dio's AuthInterceptor depends on AuthLocalDataSource
  _registerAuthDependencies();

  // Dio HTTP Client - registered AFTER auth dependencies
  _registerDio();

  // Home Feature
  _registerHomeDependencies();

  // Registration Feature
  _registerRegistrationDependencies();

  // Attendance Feature
  _registerAttendanceDependencies();

  // Invitation Feature
  _registerInvitationDependencies();
}

void _registerAuthDependencies() {
  // Data Sources
  getIt.registerLazySingleton<AuthApiClient>(
    () => AuthApiClient(getIt<Dio>()),
  );

  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSource(
      secureStorage: getIt<FlutterSecureStorage>(),
      sharedPreferences: getIt<SharedPreferences>(),
    ),
  );

  // Repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      apiClient: getIt<AuthApiClient>(),
      localDataSource: getIt<AuthLocalDataSource>(),
    ),
  );

  // Use Cases
  getIt.registerLazySingleton(() => LoginUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => RegisterUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => VerifyOtpUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => ResendOtpUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => CheckAuthUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => LogoutUseCase(getIt<AuthRepository>()));

  // Bloc - Singleton to maintain auth state across screens
  getIt.registerLazySingleton(
    () => AuthBloc(
      loginUseCase: getIt<LoginUseCase>(),
      registerUseCase: getIt<RegisterUseCase>(),
      verifyOtpUseCase: getIt<VerifyOtpUseCase>(),
      resendOtpUseCase: getIt<ResendOtpUseCase>(),
      checkAuthUseCase: getIt<CheckAuthUseCase>(),
      logoutUseCase: getIt<LogoutUseCase>(),
      authRepository: getIt<AuthRepository>(),
    ),
  );
}

void _registerDio() {
  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors in order:
    // 1. Auth Interceptor - adds Authorization header to requests
    dio.interceptors.add(
      AuthInterceptor(getIt<AuthLocalDataSource>()),
    );

    // 2. Logger Interceptor - logs all requests/responses
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
      ),
    );

    return dio;
  });
}

void _registerHomeDependencies() {
  // Data Sources
  getIt.registerLazySingleton<EventApiClient>(
    () => EventApiClient(getIt<Dio>()),
  );

  getIt.registerLazySingleton<UserApiClient>(
    () => UserApiClient(getIt<Dio>()),
  );

  // Repositories
  getIt.registerLazySingleton<EventRepository>(
    () => EventRepositoryImpl(getIt<EventApiClient>()),
  );

  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(getIt<UserApiClient>()),
  );

  // Use Cases
  getIt.registerLazySingleton(
    () => GetEventsUseCase(getIt<EventRepository>()),
  );

  getIt.registerLazySingleton(
    () => GetUserStatsUseCase(getIt<UserRepository>()),
  );

  getIt.registerLazySingleton(
    () => GetEventDetailsUseCase(getIt<EventRepository>()),
  );

  getIt.registerLazySingleton(
    () => GetRegisteredEventsUseCase(getIt<EventRepository>()),
  );

  getIt.registerLazySingleton(
    () => GetMyEventsUseCase(getIt<EventRepository>()),
  );

  getIt.registerLazySingleton(
    () => CreateEventUseCase(getIt<EventRepository>()),
  );

  getIt.registerLazySingleton(
    () => UpdateEventUseCase(getIt<EventRepository>()),
  );

  getIt.registerLazySingleton(
    () => DeleteEventUseCase(getIt<EventRepository>()),
  );

  getIt.registerLazySingleton(
    () => GetAttendeesUseCase(getIt<EventRepository>()),
  );

  getIt.registerLazySingleton(
    () => GetProfileUseCase(getIt<UserRepository>()),
  );

  getIt.registerLazySingleton(
    () => UpdateProfileUseCase(getIt<UserRepository>()),
  );

  // Cubits
  getIt.registerFactory(
    () => HomeCubit(
      getUserStatsUseCase: getIt<GetUserStatsUseCase>(),
      authRepository: getIt<AuthRepository>(),
    ),
  );

  getIt.registerFactory(
    () => EventsCubit(
      getEventsUseCase: getIt<GetEventsUseCase>(),
    ),
  );

  getIt.registerFactory(
    () => EventDetailsCubit(
      getEventDetailsUseCase: getIt<GetEventDetailsUseCase>(),
    ),
  );

  getIt.registerFactory(
    () => MyEventsCubit(
      getRegisteredEventsUseCase: getIt<GetRegisteredEventsUseCase>(),
    ),
  );

  getIt.registerFactory(
    () => CalendarCubit(
      getEventsUseCase: getIt<GetEventsUseCase>(),
    ),
  );

  getIt.registerFactory(
    () => CreateEventCubit(
      createEventUseCase: getIt<CreateEventUseCase>(),
      updateEventUseCase: getIt<UpdateEventUseCase>(),
    ),
  );

  getIt.registerFactory(
    () => EventManagementCubit(
      getMyEventsUseCase: getIt<GetMyEventsUseCase>(),
      deleteEventUseCase: getIt<DeleteEventUseCase>(),
    ),
  );

  getIt.registerFactory(
    () => AttendeesCubit(
      getAttendeesUseCase: getIt<GetAttendeesUseCase>(),
    ),
  );

  getIt.registerFactory(
    () => ProfileCubit(
      getProfileUseCase: getIt<GetProfileUseCase>(),
      updateProfileUseCase: getIt<UpdateProfileUseCase>(),
    ),
  );
}

void _registerRegistrationDependencies() {
  // Data Sources
  getIt.registerLazySingleton<RegistrationApiClient>(
    () => RegistrationApiClient(getIt<Dio>()),
  );

  // Repository
  getIt.registerLazySingleton<RegistrationRepository>(
    () => RegistrationRepositoryImpl(getIt<RegistrationApiClient>()),
  );

  // Use Cases
  getIt.registerLazySingleton(
    () => RegisterForEventUseCase(getIt<RegistrationRepository>()),
  );

  getIt.registerLazySingleton(
    () => GetRegistrationByTokenUseCase(getIt<RegistrationRepository>()),
  );

  // Cubits
  getIt.registerFactory(
    () => RegistrationCubit(
      registerForEventUseCase: getIt<RegisterForEventUseCase>(),
    ),
  );

  getIt.registerFactory(
    () => TicketCubit(
      getRegistrationByTokenUseCase: getIt<GetRegistrationByTokenUseCase>(),
      getEventDetailsUseCase: getIt<GetEventDetailsUseCase>(),
    ),
  );
}

void _registerAttendanceDependencies() {
  // Data Sources
  getIt.registerLazySingleton<AttendanceApiClient>(
    () => AttendanceApiClient(getIt<Dio>()),
  );

  // Repository
  getIt.registerLazySingleton<AttendanceRepository>(
    () => AttendanceRepositoryImpl(getIt<AttendanceApiClient>()),
  );

  // Use Cases
  getIt.registerLazySingleton(
    () => ConfirmAttendanceUseCase(getIt<AttendanceRepository>()),
  );

  // Cubit
  getIt.registerFactory(
    () => AttendanceCubit(
      confirmAttendanceUseCase: getIt<ConfirmAttendanceUseCase>(),
    ),
  );
}

void _registerInvitationDependencies() {
  // Data Sources
  getIt.registerLazySingleton<InvitationApiClient>(
    () => InvitationApiClient(getIt<Dio>()),
  );

  // Repository
  getIt.registerLazySingleton<InvitationRepository>(
    () => InvitationRepositoryImpl(getIt<InvitationApiClient>()),
  );

  // Use Cases
  getIt.registerLazySingleton(
    () => SendInvitationUseCase(getIt<InvitationRepository>()),
  );

  // Cubit
  getIt.registerFactory(
    () => InvitationCubit(
      sendInvitationUseCase: getIt<SendInvitationUseCase>(),
    ),
  );
}
