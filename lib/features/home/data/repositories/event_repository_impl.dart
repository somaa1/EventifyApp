import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/event.dart';
import '../../domain/entities/event_filter.dart';
import '../../domain/repositories/event_repository.dart';
import '../datasources/event_api_client.dart';

/// Implementation of EventRepository
class EventRepositoryImpl implements EventRepository {
  final EventApiClient _apiClient;

  EventRepositoryImpl(this._apiClient);

  @override
  Future<Either<Failure, List<Event>>> getEvents({
    EventFilter? filter,
    int? page,
    int? limit,
  }) async {
    try {
      // Convert filter to API parameters
      final response = await _apiClient.getEvents(
        page: page,
        limit: limit,
        search: filter?.searchQuery,
        eventType: filter?.eventType,
        startDate: filter?.startDate?.toIso8601String(),
        endDate: filter?.endDate?.toIso8601String(),
      );

      // Convert models to entities
      final events = response.events.map((model) => model.toEntity()).toList();

      return Right(events);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Failed to fetch events: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Event>> getEventById(String eventId) async {
    try {
      final eventModel = await _apiClient.getEventById(eventId);
      return Right(eventModel.toEntity());
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Failed to fetch event: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Event>>> getMyEvents() async {
    try {
      // For now, use getEvents with no filter
      // In the future, the API might have a specific endpoint for user's events
      final response = await _apiClient.getEvents();
      final events = response.events.map((model) => model.toEntity()).toList();
      return Right(events);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Failed to fetch my events: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Event>>> getRegisteredEvents() async {
    try {
      // For now, use getEvents with no filter
      // In the future, the API might have a specific endpoint for registered events
      final response = await _apiClient.getEvents();
      final events = response.events.map((model) => model.toEntity()).toList();
      // Filter only registered events
      final registeredEvents =
          events.where((event) => event.isRegistered).toList();
      return Right(registeredEvents);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(
          ServerFailure('Failed to fetch registered events: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Event>>> searchEvents(String query) async {
    try {
      final response = await _apiClient.getEvents(search: query);
      final events = response.events.map((model) => model.toEntity()).toList();
      return Right(events);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Failed to search events: ${e.toString()}'));
    }
  }

  /// Handle Dio errors and convert to appropriate Failures
  Failure _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ServerFailure('Connection timeout. Please try again.');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data['message'] ?? 'An error occurred';
        if (statusCode == 401) {
          return AuthFailure('Unauthorized. Please login again.');
        } else if (statusCode == 404) {
          return ServerFailure('Event not found.');
        } else {
          return ServerFailure(message);
        }
      case DioExceptionType.cancel:
        return ServerFailure('Request cancelled.');
      case DioExceptionType.connectionError:
        return NetworkFailure('No internet connection.');
      default:
        return ServerFailure('An unexpected error occurred.');
    }
  }
}
