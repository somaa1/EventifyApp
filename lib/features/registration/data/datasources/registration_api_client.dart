import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/registration_request.dart';
import '../models/registration_response.dart';
import '../models/invitation_registration_response.dart';

part 'registration_api_client.g.dart';

@RestApi()
abstract class RegistrationApiClient {
  factory RegistrationApiClient(Dio dio, {String baseUrl}) =
      _RegistrationApiClient;

  @POST('/registrations')
  Future<RegistrationResponse> registerForEvent(
      @Body() RegistrationRequest request);

  @GET('/registrations/{token}')
  Future<RegistrationResponse> getRegistrationByToken(
      @Path('token') String token);

  @GET('/registrations/by-invitation/{token}')
  Future<InvitationRegistrationResponse> getRegistrationByInvitation(
      @Path('token') String token);
}
