import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/event_model.dart';
import '../models/events_response.dart';

part 'event_api_client.g.dart';

/// Retrofit API client for event-related endpoints
@RestApi()
abstract class EventApiClient {
  factory EventApiClient(Dio dio, {String baseUrl}) = _EventApiClient;

  /// Get list of all events
  ///
  /// GET /api/v1/events
  ///
  /// Query parameters:
  /// - page: Page number for pagination
  /// - limit: Number of items per page
  /// - search: Search query
  /// - eventType: Filter by event type
  /// - startDate: Filter by start date
  /// - endDate: Filter by end date
  @GET('/events')
  Future<EventsResponse> getEvents({
    @Query('page') int? page,
    @Query('limit') int? limit,
    @Query('search') String? search,
    @Query('eventType') String? eventType,
    @Query('startDate') String? startDate,
    @Query('endDate') String? endDate,
  });

  /// Get a single event by ID
  ///
  /// GET /api/v1/events/{id}
  @GET('/events/{id}')
  Future<EventModel> getEventById(@Path('id') String id);

  /// Create a new event (ORGANIZER/ADMIN only)
  ///
  /// POST /api/v1/events
  @POST('/events')
  Future<EventModel> createEvent(@Body() Map<String, dynamic> eventData);

  /// Update an existing event (ORGANIZER/ADMIN only)
  ///
  /// PUT /api/v1/events/{id}
  @PUT('/events/{id}')
  Future<EventModel> updateEvent(
    @Path('id') String id,
    @Body() Map<String, dynamic> eventData,
  );

  /// Delete an event (ORGANIZER/ADMIN only)
  ///
  /// DELETE /api/v1/events/{id}
  @DELETE('/events/{id}')
  Future<void> deleteEvent(@Path('id') String id);
}
