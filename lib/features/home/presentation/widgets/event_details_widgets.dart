import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/event.dart';

/// Event Header with hero image and gradient overlay
class EventHeader extends StatelessWidget {
  final Event event;
  final VoidCallback onBack;

  const EventHeader({
    super.key,
    required this.event,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250.h,
      child: Stack(
        children: [
          // Background Image
          Container(
            width: double.infinity,
            height: 250.h,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              image: event.imageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(event.imageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: event.imageUrl == null
                ? Center(
                    child: Icon(
                      Icons.event,
                      size: 80.r,
                      color: AppColors.surface.withOpacity(0.5),
                    ),
                  )
                : null,
          ),

          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.6),
                  Colors.transparent,
                  Colors.black.withOpacity(0.8),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),

          // Back Button
          Positioned(
            top: 8.h,
            left: 8.w,
            child: SafeArea(
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 24.r,
                ),
                onPressed: onBack,
              ),
            ),
          ),

          // Event Type Badge
          Positioned(
            top: 16.h,
            right: 16.w,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 6.h,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                event.eventType,
                style: AppTextStyles.caption.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          // Status Badge
          Positioned(
            bottom: 16.h,
            right: 16.w,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 6.h,
              ),
              decoration: BoxDecoration(
                color: _getStatusColor(event.status),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                event.status,
                style: AppTextStyles.caption.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'UPCOMING':
        return AppColors.primary;
      case 'ONGOING':
        return AppColors.success;
      case 'COMPLETED':
        return AppColors.textSecondary;
      case 'CANCELLED':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }
}

/// Event Info Section with date, location, and capacity
class EventInfoSection extends StatelessWidget {
  final Event event;

  const EventInfoSection({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          event.title,
          style: AppTextStyles.headingLarge.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: AppSpacing.md),

        // Date & Time
        _InfoRow(
          icon: Icons.calendar_today,
          text: _formatDateRange(),
        ),
        SizedBox(height: AppSpacing.sm),

        // Location
        _InfoRow(
          icon: Icons.location_on,
          text: event.location,
        ),
        SizedBox(height: AppSpacing.md),

        // Capacity Indicator
        EventCapacityIndicator(event: event),
      ],
    );
  }

  String _formatDateRange() {
    final start = DateFormat('MMM dd, yyyy • HH:mm').format(event.startDateTime);
    final end = DateFormat('HH:mm').format(event.endDateTime);
    return '$start - $end';
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20.r,
          color: AppColors.primary,
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

/// Event Capacity Indicator with progress bar
class EventCapacityIndicator extends StatelessWidget {
  final Event event;

  const EventCapacityIndicator({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = event.capacity > 0
        ? (event.attendeeCount / event.capacity).clamp(0.0, 1.0)
        : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Capacity',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${event.attendeeCount} / ${event.capacity}',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(10.r),
          child: LinearProgressIndicator(
            value: percentage,
            minHeight: 8.h,
            backgroundColor: AppColors.surface,
            valueColor: AlwaysStoppedAnimation<Color>(
              event.isFull ? AppColors.error : AppColors.primary,
            ),
          ),
        ),
        if (event.remainingSpots > 0 && event.remainingSpots <= 10)
          Padding(
            padding: EdgeInsets.only(top: 4.h),
            child: Text(
              'Only ${event.remainingSpots} spots left!',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.warning,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}

/// Expandable Event Description
class EventDescription extends StatefulWidget {
  final Event event;

  const EventDescription({
    super.key,
    required this.event,
  });

  @override
  State<EventDescription> createState() => _EventDescriptionState();
}

class _EventDescriptionState extends State<EventDescription> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final maxLines = _isExpanded ? null : 3;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About',
          style: AppTextStyles.headingSmall.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        Text(
          widget.event.description,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            height: 1.5,
          ),
          maxLines: maxLines,
          overflow: _isExpanded ? null : TextOverflow.ellipsis,
        ),
        if (widget.event.description.length > 150)
          TextButton(
            onPressed: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              _isExpanded ? 'Show less' : 'Read more',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}

/// Event Organizer Card
class EventOrganizerCard extends StatelessWidget {
  final Event event;

  const EventOrganizerCard({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    // Safely derive an initial; backend currently doesn't return organizer info
    final hasName = event.organizerName.isNotEmpty;
    final initial = hasName ? event.organizerName[0].toUpperCase() : '?';
    final displayName = hasName ? event.organizerName : 'Organizer';

    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.primaryLight.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24.r,
            backgroundColor: AppColors.primary,
            child: Text(
              initial,
              style: AppTextStyles.bodyLarge.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Organized by',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  displayName,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            size: 24.r,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}

/// Event Action Buttons (Register/View Ticket/Manage)
class EventActionButtons extends StatelessWidget {
  final Event event;
  final VoidCallback? onRegister;
  final VoidCallback? onViewTicket;
  final VoidCallback? onManage;
  final bool isLoading;

  const EventActionButtons({
    super.key,
    required this.event,
    this.onRegister,
    this.onViewTicket,
    this.onManage,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (event.isRegistered && onViewTicket != null) {
      return _buildViewTicketButton();
    } else if (onManage != null) {
      return _buildManageButton();
    } else if (onRegister != null) {
      return _buildRegisterButton();
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildRegisterButton() {
    final canRegister = !event.isFull && event.isUpcoming;

    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: ElevatedButton(
        onPressed: canRegister && !isLoading ? onRegister : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.textSecondary.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: isLoading
            ? SizedBox(
                height: 20.h,
                width: 20.w,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                event.isFull ? 'Event Full' : 'Register Now',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _buildViewTicketButton() {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: ElevatedButton.icon(
        onPressed: onViewTicket,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.success,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        icon: Icon(Icons.qr_code, size: 24.r),
        label: Text(
          'View Ticket',
          style: AppTextStyles.bodyLarge.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildManageButton() {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: ElevatedButton(
        onPressed: onManage,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.settings, size: 22.r, color: Colors.white),
            SizedBox(width: 8.w),
            Text(
              'Manage Event',
              style: AppTextStyles.bodyLarge.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
