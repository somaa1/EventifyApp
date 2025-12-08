import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/event.dart';

/// Event card for My Events list
class MyEventCard extends StatelessWidget {
  final Event event;
  final bool isPast;

  const MyEventCard({
    super.key,
    required this.event,
    this.isPast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isPast ? AppColors.divider : AppColors.primary.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            context.push('/events/${event.id}');
          },
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with date and status
                Row(
                  children: [
                    _buildDateBadge(),
                    const Spacer(),
                    if (isPast)
                      _buildStatusBadge('Attended', AppColors.textSecondary)
                    else
                      _buildStatusBadge('Registered', AppColors.success),
                  ],
                ),
                SizedBox(height: AppSpacing.md),

                // Event Title
                Text(
                  event.title,
                  style: AppTextStyles.textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isPast ? AppColors.textSecondary : AppColors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: AppSpacing.sm),

                // Event Info
                _buildInfoRow(
                  Icons.access_time_outlined,
                  DateFormat('hh:mm a').format(event.startDateTime),
                ),
                SizedBox(height: 6.h),
                _buildInfoRow(
                  Icons.location_on_outlined,
                  event.location,
                ),
                SizedBox(height: AppSpacing.md),

                // Action Buttons for organizer view (invite/attendees/edit)
                _buildOrganizerActions(context),

                // Action Button
                _buildActionButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrganizerActions(BuildContext context) {
    // Only show for organizers/admins; since role not on entity, show when not past
    if (isPast) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          _ActionTextButton(
            icon: Icons.mail_outline,
            label: 'Invite',
            onTap: () => context.push('/events/${event.id}/invite'),
          ),
          SizedBox(width: AppSpacing.lg),
          _ActionTextButton(
            icon: Icons.group_outlined,
            label: 'Attendees',
            onTap: () => context.push('/events/${event.id}/attendees'),
          ),
          const Spacer(),
          IconButton(
            icon: Icon(Icons.edit, size: 20.r, color: AppColors.primary),
            tooltip: 'Edit',
            onPressed: () => context.push('/edit-event/${event.id}'),
          ),
        ],
      ),
    );
  }

  Widget _buildDateBadge() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 6.h,
      ),
      decoration: BoxDecoration(
        color: isPast
            ? AppColors.surfaceVariant
            : AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 14.r,
            color: isPast ? AppColors.textSecondary : AppColors.primary,
          ),
          SizedBox(width: 4.w),
          Text(
            DateFormat('MMM dd, yyyy').format(event.startDateTime),
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
              color: isPast ? AppColors.textSecondary : AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 4.h,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.w,
            height: 6.h,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 4.w),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16.r,
          color: isPast ? AppColors.textDisabled : AppColors.textSecondary,
        ),
        SizedBox(width: 6.w),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.bodySmall.copyWith(
              color: isPast ? AppColors.textSecondary : AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context) {
    if (isPast) {
      return OutlinedButton(
        onPressed: () {
          context.push('/events/${event.id}');
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textSecondary,
          side: BorderSide(color: AppColors.border),
          padding: EdgeInsets.symmetric(vertical: 10.h),
          minimumSize: Size(double.infinity, 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
        child: Text(
          'View Details',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    } else {
      return ElevatedButton(
        onPressed: () {
          context.push('/events/${event.id}');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 12.h),
          minimumSize: Size(double.infinity, 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          elevation: 0,
        ),
        child: Text(
          'View Details',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }
  }
}

class _ActionTextButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionTextButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20.r, color: AppColors.primary),
          SizedBox(width: 6.w),
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// Empty state widget for when there are no events
class EmptyEventsState extends StatelessWidget {
  final String message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyEventsState({
    super.key,
    required this.message,
    this.icon = Icons.event_busy_outlined,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 64.r,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: AppSpacing.lg),
            Text(
              message,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: AppSpacing.lg),
              ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                    vertical: 14.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  actionLabel!,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
