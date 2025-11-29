import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/invitation_response.dart';

part 'invitation_api_client.g.dart';

@RestApi()
abstract class InvitationApiClient {
  factory InvitationApiClient(Dio dio, {String baseUrl}) =
      _InvitationApiClient;

  @POST('/invitations/send')
  Future<InvitationResponse> sendInvitation(
    @Query('eventId') int eventId,
    @Query('email') String email,
  );
}
