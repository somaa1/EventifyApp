import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/auth_response_model.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';

part 'auth_api_client.g.dart';

@RestApi()
abstract class AuthApiClient {
  factory AuthApiClient(Dio dio, {String baseUrl}) = _AuthApiClient;

  @POST('/auth/login')
  Future<AuthResponseModel> login(@Body() LoginRequest request);

  @POST('/auth/register')
  Future<AuthResponseModel> register(@Body() RegisterRequest request);

  @POST('/auth/verify-otp')
  Future<AuthResponseModel> verifyOtp(
    @Query('email') String email,
    @Query('otp') String otp,
  );

  @POST('/auth/resend-otp')
  Future<String> resendOtp(@Query('email') String email);
}
