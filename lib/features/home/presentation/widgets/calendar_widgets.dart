import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/event.dart';

/// Calendar event marker
class EventMarker extends StatelessWidget {
  final int count;

  const EventMarker({
    super.key,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    if (count == 0) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.only(top: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          count > 3 ? 3 : count,
          (index) => Container(
            width: 4.w,
            height: 4.h,
            margin: EdgeInsets.symmetric(horizontal: 1.w),
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

/// Event list item for calendar selected day
class CalendarEventItem extends StatelessWidget {
  final Event event;

  const CalendarEventItem({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: _getEventTypeColor().withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            context.push('/events/${event.id}');
          },
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                // Event type indicator
                Container(
                  width: 4.w,
                  height: 60.h,
                  decoration: BoxDecoration(
                    color: _getEventTypeColor(),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                SizedBox(width: AppSpacing.md),

                // Event details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_outlined,
                            size: 14.r,
                            color: AppColors.textSecondary,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            DateFormat('hh:mm a').format(event.startDateTime),
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(width: AppSpacing.sm),
                          Icon(
                            Icons.location_on_outlined,
                            size: 14.r,
                            color: AppColors.textSecondary,
                          ),
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
                        ],
                      ),
                      SizedBox(height: 6.h),
                      _buildStatusBadge(),
                    ],
                  ),
                ),

                // Arrow icon
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16.r,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8.w,
        vertical: 3.h,
      ),
      decoration: BoxDecoration(
        color: _getStatusColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        _formatEventType(event.eventType),
        style: AppTextStyles.bodySmall.copyWith(
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
          color: _getStatusColor(),
        ),
      ),
    );
  }

  Color _getEventTypeColor() {
    switch (event.eventType.toUpperCase()) {
      case 'CONFERENCE':
        return AppColors.primary;
      case 'WORKSHOP':
        return AppColors.secondary;
      case 'SEMINAR':
        return AppColors.info;
      case 'MEETUP':
        return AppColors.warning;
      default:
        return AppColors.textSecondary;
    }
  }

  Color _getStatusColor() {
    switch (event.status.toUpperCase()) {
      case 'UPCOMING':
        return AppColors.success;
      case 'ONGOING':
        return AppColors.info;
      case 'COMPLETED':
        return AppColors.textSecondary;
      case 'CANCELLED':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  String _formatEventType(String type) {
    return type.split('_').map((word) {
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }
}

/// Empty state for no events on selected day
class NoEventsOnDay extends StatelessWidget {
  final DateTime day;

  const NoEventsOnDay({
    super.key,
    required this.day,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy_outlined,
              size: 64.r,
              color: AppColors.textDisabled,
            ),
            SizedBox(height: AppSpacing.md),
            Text(
              'No events on ${DateFormat('MMM dd, yyyy').format(day)}',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
