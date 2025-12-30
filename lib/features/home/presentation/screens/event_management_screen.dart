import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../cubit/event_management_cubit.dart';
import '../cubit/event_management_state.dart';
import '../../domain/entities/event.dart';

class EventManagementScreen extends StatelessWidget {
  const EventManagementScreen({super.key});

  void _confirmDelete(BuildContext context, String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Event'),
        content: const Text('Are you sure you want to delete this event?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      context.read<EventManagementCubit>().deleteEvent(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<EventManagementCubit>()..loadEvents(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Manage Events'),
          backgroundColor: AppColors.surface,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () => context.push(AppRouter.createEvent),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: BlocConsumer<EventManagementCubit, EventManagementState>(
          listener: (context, state) {
            if (state is EventManagementError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.error,
                  duration: const Duration(seconds: 4),
                  action: SnackBarAction(
                    label: 'Dismiss',
                    textColor: Colors.white,
                    onPressed: () {},
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is EventManagementLoading ||
                state is EventManagementInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is EventManagementError) {
              return Center(
                child: Text(
                  state.message,
                  style: AppTextStyles.bodyMedium,
                ),
              );
            }

            // Handle both Loaded and Deleting states
            final events = state is EventManagementLoaded
                ? state.events
                : state is EventManagementDeleting
                    ? state.events
                    : <Event>[];

            final deletingEventId = state is EventManagementDeleting
                ? state.deletingEventId
                : null;

            if (events.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.event_busy,
                        size: 64.r, color: AppColors.textSecondary),
                    SizedBox(height: AppSpacing.md),
                    Text(
                      'No events yet',
                      style: AppTextStyles.headingSmall,
                    ),
                    SizedBox(height: AppSpacing.sm),
                    Text(
                      'Create your first event to get started!',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => context.read<EventManagementCubit>().refresh(),
              child: ListView.builder(
                padding: EdgeInsets.all(AppSpacing.md),
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  final isDeleting = deletingEventId == event.id;

                  return _EventTile(
                    event: event,
                    isDeleting: isDeleting,
                    onEdit: () => context.push(
                      AppRouter.editEvent.replaceAll(':id', event.id),
                      extra: event,
                    ),
                    onDelete: () => _confirmDelete(context, event.id),
                    onInvite: () => context.push(
                      AppRouter.sendInvitation.replaceAll(':id', event.id),
                    ),
                    onAttendees: () => context.push(
                      AppRouter.attendeeList.replaceAll(':id', event.id),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class _EventTile extends StatelessWidget {
  final Event event;
  final bool isDeleting;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onInvite;
  final VoidCallback onAttendees;

  const _EventTile({
    required this.event,
    required this.isDeleting,
    required this.onEdit,
    required this.onDelete,
    required this.onInvite,
    required this.onAttendees,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      margin: EdgeInsets.only(bottom: AppSpacing.md),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event title and type
            Row(
              children: [
                Expanded(
                  child: Text(
                    event.title,
                    style: AppTextStyles.headingSmall.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    event.eventType,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),

            // Description
            Text(
              event.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 8.h),

            // Location and capacity
            Row(
              children: [
                Icon(Icons.location_on,
                    size: 14.r, color: AppColors.textSecondary),
                SizedBox(width: 4.w),
                Expanded(
                  child: Text(
                    event.location,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(Icons.people, size: 14.r, color: AppColors.textSecondary),
                SizedBox(width: 4.w),
                Text(
                  '${event.attendeeCount ?? 0}/${event.capacity}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.sm),

            // Action buttons - RESPONSIVE WRAP LAYOUT
            Wrap(
              spacing: 4.w,
              runSpacing: 4.h,
              alignment: WrapAlignment.end,
              children: [
                _ActionButton(
                  icon: Icons.mail_outline,
                  label: 'Invite',
                  onPressed: isDeleting ? null : onInvite,
                  color: AppColors.info,
                ),
                _ActionButton(
                  icon: Icons.group,
                  label: 'Attendees',
                  onPressed: isDeleting ? null : onAttendees,
                  color: AppColors.secondary,
                ),
                _ActionButton(
                  icon: Icons.edit,
                  label: 'Edit',
                  onPressed: isDeleting ? null : onEdit,
                  color: AppColors.primary,
                ),
                _ActionButton(
                  icon: Icons.delete_outline,
                  label: 'Delete',
                  onPressed: isDeleting ? null : onDelete,
                  color: AppColors.error,
                  isLoading: isDeleting,
                  isDangerous: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// NEW: Compact action button widget
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final Color color;
  final bool isLoading;
  final bool isDangerous;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.color,
    this.isLoading = false,
    this.isDangerous = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32.h,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: isLoading
            ? SizedBox(
                width: 14.w,
                height: 14.h,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              )
            : Icon(icon, size: 16.r),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(
            color: isDangerous ? color : color.withOpacity(0.3),
            width: isDangerous ? 1.5 : 1,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 8.w,
            vertical: 4.h,
          ),
          minimumSize: Size(0, 32.h),
          visualDensity: VisualDensity.compact,
        ),
      ),
    );
  }
}
