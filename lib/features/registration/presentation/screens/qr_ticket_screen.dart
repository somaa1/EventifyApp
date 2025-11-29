import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../cubit/ticket_cubit.dart';
import '../cubit/ticket_state.dart';
import '../widgets/ticket_widgets.dart';
import '../../../home/presentation/widgets/error_view.dart';
import '../../domain/entities/registration.dart';
import '../../../home/domain/entities/event.dart';

class QrTicketScreen extends StatelessWidget {
  final String registrationToken;

  const QrTicketScreen({
    super.key,
    required this.registrationToken,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<TicketCubit>()..loadTicket(registrationToken),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: AppColors.textPrimary,
              size: 24.r,
            ),
            onPressed: () => context.pop(),
          ),
          title: Text(
            'My Ticket',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(
                Icons.more_vert,
                color: AppColors.textPrimary,
                size: 24.r,
              ),
              onPressed: () {
                _showTicketOptions(context);
              },
            ),
          ],
        ),
        body: BlocBuilder<TicketCubit, TicketState>(
          builder: (context, state) {
            if (state is TicketLoading) {
              return _buildLoadingState();
            } else if (state is TicketLoaded) {
              return _buildLoadedState(context, state);
            } else if (state is TicketError) {
              return _buildErrorState(context, state.message);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    // Create dummy data for skeleton
    final dummyRegistration = Registration(
      id: 1,
      userId: 1,
      eventId: 1,
      registrationToken: 'LOADING-TOKEN-12345678',
      registeredAt: DateTime.now(),
    );

    final dummyEvent = Event(
      id: '1',
      title: 'Loading Event Title',
      description: 'Loading description',
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
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: AppSpacing.lg),
            TicketCard(
              registration: dummyRegistration,
              event: dummyEvent,
            ),
            SizedBox(height: AppSpacing.lg),
            const ImportantNoticeCard(),
            SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadedState(BuildContext context, TicketLoaded state) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<TicketCubit>().refreshTicket(registrationToken);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: AppSpacing.lg),

            // Main Ticket Card
            TicketCard(
              registration: state.registration,
              event: state.event,
            ),

            SizedBox(height: AppSpacing.lg),

            // Important Notice
            const ImportantNoticeCard(),

            SizedBox(height: AppSpacing.lg),

            // Action Buttons
            TicketActionButtons(
              onShare: () => _handleShare(context, state),
              onAddToCalendar: () => _handleAddToCalendar(context, state),
            ),

            SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return ErrorView(
      message: message,
      onRetry: () {
        context.read<TicketCubit>().loadTicket(registrationToken);
      },
    );
  }

  void _showTicketOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.r),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: AppSpacing.sm),
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: AppSpacing.md),
              _OptionItem(
                icon: Icons.download_outlined,
                title: 'Download Ticket',
                onTap: () {
                  Navigator.pop(sheetContext);
                  _handleDownload(context);
                },
              ),
              _OptionItem(
                icon: Icons.share_outlined,
                title: 'Share Ticket',
                onTap: () {
                  Navigator.pop(sheetContext);
                  final state = context.read<TicketCubit>().state;
                  if (state is TicketLoaded) {
                    _handleShare(context, state);
                  }
                },
              ),
              _OptionItem(
                icon: Icons.event_outlined,
                title: 'View Event Details',
                onTap: () {
                  Navigator.pop(sheetContext);
                  final state = context.read<TicketCubit>().state;
                  if (state is TicketLoaded) {
                    context.push('/event/${state.event.id}');
                  }
                },
              ),
              SizedBox(height: AppSpacing.md),
            ],
          ),
        );
      },
    );
  }

  void _handleShare(BuildContext context, TicketLoaded state) {
    // TODO: Implement share functionality (Phase 10)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Share functionality coming soon!'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _handleAddToCalendar(BuildContext context, TicketLoaded state) {
    // TODO: Implement add to calendar functionality (Phase 10)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Add to calendar functionality coming soon!'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _handleDownload(BuildContext context) {
    // TODO: Implement download ticket as PDF/image (Phase 10)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Download functionality coming soon!'),
        backgroundColor: AppColors.info,
      ),
    );
  }
}

/// Bottom sheet option item widget
class _OptionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _OptionItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.textPrimary,
              size: 24.r,
            ),
            SizedBox(width: AppSpacing.md),
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
