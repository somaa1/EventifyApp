import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/modern_dialog.dart';
import '../cubit/event_details_cubit.dart';
import '../cubit/event_details_state.dart';
import '../widgets/event_details_widgets.dart';
import '../widgets/error_view.dart';
import '../../domain/entities/event.dart';
import '../../../registration/presentation/cubit/registration_cubit.dart';
import '../../../registration/presentation/cubit/registration_state.dart';
import '../../../registration/presentation/widgets/registration_confirmation_dialog.dart';
import '../../../registration/presentation/widgets/registration_success_dialog.dart';

class EventDetailsScreen extends StatelessWidget {
  final String eventId;

  const EventDetailsScreen({
    super.key,
    required this.eventId,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<EventDetailsCubit>()..loadEventDetails(eventId),
        ),
        BlocProvider(
          create: (context) => getIt<RegistrationCubit>(),
        ),
      ],
      child: BlocListener<RegistrationCubit, RegistrationState>(
        listener: (context, state) {
          if (state is RegistrationSuccess) {
            // Close any open dialogs
            Navigator.of(context).pop();

            // Show success dialog
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (dialogContext) => RegistrationSuccessDialog(
                eventTitle: context.read<EventDetailsCubit>().state is EventDetailsLoaded
                    ? (context.read<EventDetailsCubit>().state as EventDetailsLoaded).event.title
                    : 'Event',
                onViewTicket: () {
                  Navigator.of(dialogContext).pop();
                  _handleViewTicket(context, state.registration);
                },
              ),
            );

            // Refresh event details to update registration status
            context.read<EventDetailsCubit>().refreshEventDetails(eventId);
          } else if (state is RegistrationError) {
            // Close loading dialog if open
            Navigator.of(context).pop();

            // Show error snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
                action: SnackBarAction(
                  label: 'Dismiss',
                  textColor: Colors.white,
                  onPressed: () {},
                ),
              ),
            );
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: BlocBuilder<EventDetailsCubit, EventDetailsState>(
            builder: (context, state) {
              if (state is EventDetailsLoading) {
                return _buildLoadingState();
              } else if (state is EventDetailsLoaded) {
                return _buildLoadedState(context, state.event);
              } else if (state is EventDetailsError) {
                return _buildErrorState(context, state.message);
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    // Create a dummy event for skeleton
    final dummyEvent = Event(
      id: '1',
      title: 'Loading Event Title Here',
      description: 'Loading description that will be replaced with actual content when the data loads from the server.',
      location: 'Loading Location',
      startDateTime: DateTime.now(),
      endDateTime: DateTime.now().add(const Duration(hours: 2)),
      eventType: 'CONFERENCE',
      capacity: 100,
      attendeeCount: 50,
      organizerName: 'Organizer Name',
      organizerId: '1',
      status: 'UPCOMING',
    );

    return Skeletonizer(
      enabled: true,
      child: _buildEventDetailsContent(null, dummyEvent),
    );
  }

  Widget _buildLoadedState(BuildContext context, Event event) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<EventDetailsCubit>().refreshEventDetails(eventId);
      },
      child: _buildEventDetailsContent(context, event),
    );
  }

  Widget _buildEventDetailsContent(BuildContext? context, Event event) {
    return CustomScrollView(
      slivers: [
        // Event Header (Hero Image)
        SliverToBoxAdapter(
          child: EventHeader(
            event: event,
            onBack: () => context?.pop(),
          ),
        ),

        // Event Content
        SliverPadding(
          padding: EdgeInsets.all(AppSpacing.md),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Event Info Section
              EventInfoSection(event: event),
              SizedBox(height: AppSpacing.lg),

              // Description
              EventDescription(event: event),
              SizedBox(height: AppSpacing.lg),

              // Organizer Card
              EventOrganizerCard(event: event),
              SizedBox(height: AppSpacing.xl),

              // Action Buttons
              if (context != null)
                BlocBuilder<RegistrationCubit, RegistrationState>(
                  builder: (ctx, regState) {
                    return EventActionButtons(
                      event: event,
                      onRegister: () => _handleRegister(context, event),
                      onViewTicket: event.isRegistered
                          ? () => _handleViewTicketFromEvent(context, event)
                          : null,
                      onManage: () => _handleManage(context, event),
                      isLoading: regState is RegistrationLoading,
                    );
                  },
                ),

              SizedBox(height: AppSpacing.xl),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return SafeArea(
      child: Column(
        children: [
          // Back button
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: AppColors.textPrimary,
                size: 24.r,
              ),
              onPressed: () => context.pop(),
            ),
          ),

          // Error View
          Expanded(
            child: ErrorView(
              message: message,
              onRetry: () {
                context.read<EventDetailsCubit>().loadEventDetails(eventId);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _handleRegister(BuildContext context, Event event) {
    showDialog(
      context: context,
      builder: (dialogContext) => RegistrationConfirmationDialog(
        event: event,
        onConfirm: () {
          // Close confirmation dialog
          Navigator.of(dialogContext).pop();

          // Show loading dialog
          showModernDialog(
            context: context,
            barrierDismissible: false,
            useGlass: true,
            title: 'Registering',
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
                SizedBox(height: AppSpacing.md),
                Text(
                  'Please wait while we register you for this event...',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );

          // Trigger registration
          context.read<RegistrationCubit>().registerForEvent(
                eventId: int.parse(event.id),
              );
        },
        onCancel: () {
          Navigator.of(dialogContext).pop();
        },
      ),
    );
  }

  void _handleViewTicket(BuildContext context, dynamic registration) {
    // Navigate to QR ticket screen with registration token
    if (registration != null && registration.registrationToken != null) {
      context.push('/ticket/${registration.registrationToken}');
    }
  }

  void _handleViewTicketFromEvent(BuildContext context, Event event) {
    // Navigate to QR ticket screen for registered event
    // Note: We'll need to get the registration token from the event or user's registrations
    // For now, this is a placeholder until we have the registration data in the event
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ticket feature available after registration!'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _handleManage(BuildContext context, Event event) {
    context.push(AppRouter.eventManagement);
  }
}
