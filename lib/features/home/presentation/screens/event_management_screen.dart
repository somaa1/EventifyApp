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
                SnackBar(content: Text(state.message)),
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

            if (state is EventManagementLoaded) {
              if (state.events.isEmpty) {
                return Center(
                  child: Text(
                    'No events yet. Create your first event!',
                    style: AppTextStyles.bodyMedium,
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () => context.read<EventManagementCubit>().refresh(),
                child: ListView.builder(
                  padding: EdgeInsets.all(AppSpacing.md),
                  itemCount: state.events.length,
                  itemBuilder: (context, index) {
                    final event = state.events[index];
                    return _EventTile(
                      event: event,
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
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _EventTile extends StatelessWidget {
  final Event event;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onInvite;
  final VoidCallback onAttendees;

  const _EventTile({
    required this.event,
    required this.onEdit,
    required this.onDelete,
    required this.onInvite,
    required this.onAttendees,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      margin: EdgeInsets.only(bottom: AppSpacing.sm),
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.title,
              style: AppTextStyles.headingSmall.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              event.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Chip(
                  label: Text(event.eventType),
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  labelStyle: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                Text(
                  'Capacity: ${event.capacity}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: onInvite,
                  icon: const Icon(Icons.mail_outline),
                  label: const Text('Invite'),
                ),
                TextButton.icon(
                  onPressed: onAttendees,
                  icon: const Icon(Icons.group),
                  label: const Text('Attendees'),
                ),
                TextButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit'),
                ),
                TextButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Delete'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
