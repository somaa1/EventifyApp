import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/modern_dialog.dart';
import '../../../../core/widgets/modern_button.dart';
import '../cubit/event_management_cubit.dart';
import '../cubit/event_management_state.dart';
import '../../domain/entities/event.dart';

class EventManagementScreen extends StatelessWidget {
  const EventManagementScreen({super.key});

  void _confirmDelete(BuildContext context, String id) async {
    final confirm = await showModernDialog<bool>(
      context: context,
      useGlass: true,
      title: 'Delete Event',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: AppColors.error,
            size: 48.r,
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            'Are you sure you want to delete this event?',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            'This action cannot be undone.',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.error,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(
            'Cancel',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
        ModernButton(
          onPressed: () => Navigator.pop(context, true),
          type: ModernButtonType.danger,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.delete, size: 18.r, color: Colors.white),
              SizedBox(width: 6.w),
              const Text('Delete'),
            ],
          ),
        ),
      ],
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

class _EventTile extends StatefulWidget {
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
  State<_EventTile> createState() => _EventTileState();
}

class _EventTileState extends State<_EventTile> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: Container(
        margin: EdgeInsets.only(bottom: AppSpacing.md),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: AppShadows.medium(AppColors.isDarkMode),
        ),
        child: GlassContainer(
          blur: 15,
          opacity: 0.1,
          borderRadius: BorderRadius.circular(16.r),
          padding: EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            // Event title and type
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.event.title,
                    style: AppTextStyles.headingSmall.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                GlassContainer(
                  blur: 10,
                  opacity: 0.15,
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 5.h,
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withAlpha((0.3 * 255).round()),
                      AppColors.primary.withAlpha((0.2 * 255).round()),
                    ],
                  ),
                  child: Text(
                    widget.event.eventType,
                    style: AppTextStyles.caption.copyWith(
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
              widget.event.description,
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
                    size: 16.r, color: AppColors.secondary),
                SizedBox(width: 4.w),
                Expanded(
                  child: Text(
                    widget.event.location,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(Icons.people, size: 16.r, color: AppColors.primary),
                SizedBox(width: 4.w),
                Text(
                  '${widget.event.attendeeCount ?? 0}/${widget.event.capacity}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.sm),

            // Action buttons - RESPONSIVE WRAP LAYOUT
            Wrap(
              spacing: 6.w,
              runSpacing: 6.h,
              alignment: WrapAlignment.end,
              children: [
                _ActionButton(
                  icon: Icons.mail_outline,
                  label: 'Invite',
                  onPressed: widget.isDeleting ? null : widget.onInvite,
                  color: AppColors.info,
                ),
                _ActionButton(
                  icon: Icons.group,
                  label: 'Attendees',
                  onPressed: widget.isDeleting ? null : widget.onAttendees,
                  color: AppColors.secondary,
                ),
                _ActionButton(
                  icon: Icons.edit,
                  label: 'Edit',
                  onPressed: widget.isDeleting ? null : widget.onEdit,
                  color: AppColors.primary,
                ),
                _ActionButton(
                  icon: Icons.delete_outline,
                  label: 'Delete',
                  onPressed: widget.isDeleting ? null : widget.onDelete,
                  color: AppColors.error,
                  isLoading: widget.isDeleting,
                  isDangerous: true,
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    )
        .animate(target: _isPressed ? 1 : 0)
        .scale(begin: const Offset(1, 1), end: const Offset(0.98, 0.98));
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
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 32.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: isDangerous
              ? [
                  BoxShadow(
                    color: color.withAlpha((0.3 * 255).round()),
                    blurRadius: 4.r,
                    offset: Offset(0, 2.h),
                  ),
                ]
              : null,
        ),
        child: GlassContainer(
          blur: 10,
          opacity: isDangerous ? 0.15 : 0.08,
          borderRadius: BorderRadius.circular(20.r),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          gradient: isDangerous
              ? LinearGradient(
                  colors: [
                    color.withAlpha((0.2 * 255).round()),
                    color.withAlpha((0.1 * 255).round()),
                  ],
                )
              : null,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isLoading)
                SizedBox(
                  width: 14.w,
                  height: 14.h,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                )
              else
                Icon(icon, size: 16.r, color: color),
              SizedBox(width: 6.w),
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
