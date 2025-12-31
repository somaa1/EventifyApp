import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/modern_button.dart';
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
          // Background Image with Hero Animation
          Hero(
            tag: 'event-${event.id}',
            child: Container(
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
                        color: AppColors.surface.withAlpha((0.5 * 255).round()),
                      ),
                    )
                  : null,
            ),
          ),

          // Enhanced Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withAlpha((0.7 * 255).round()),
                  Colors.transparent,
                  Colors.black.withAlpha((0.85 * 255).round()),
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

          // Event Type Badge with Glassmorphism
          Positioned(
            top: 16.h,
            right: 16.w,
            child: SafeArea(
              child: GlassContainer(
                blur: 15,
                opacity: 0.2,
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 6.h,
                ),
                borderRadius: BorderRadius.circular(20.r),
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withAlpha((0.4 * 255).round()),
                    AppColors.primary.withAlpha((0.3 * 255).round()),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6.r,
                      height: 6.r,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      event.eventType,
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Status Badge with Glassmorphism
          Positioned(
            bottom: 16.h,
            right: 16.w,
            child: GlassContainer(
              blur: 15,
              opacity: 0.2,
              padding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 6.h,
              ),
              borderRadius: BorderRadius.circular(20.r),
              gradient: LinearGradient(
                colors: [
                  _getStatusColor(event.status).withAlpha((0.4 * 255).round()),
                  _getStatusColor(event.status).withAlpha((0.3 * 255).round()),
                ],
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

        // Info Card with Glassmorphism
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: AppShadows.small(AppColors.isDarkMode),
          ),
          child: GlassContainer(
            blur: 15,
            opacity: 0.1,
            borderRadius: BorderRadius.circular(16.r),
            padding: EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                // Date & Time
                _InfoRow(
                  icon: Icons.calendar_today,
                  iconColor: AppColors.primary,
                  text: _formatDateRange(),
                ),
                SizedBox(height: AppSpacing.sm),

                // Location
                _InfoRow(
                  icon: Icons.location_on,
                  iconColor: AppColors.secondary,
                  text: event.location,
                ),
                SizedBox(height: AppSpacing.md),

                // Capacity Indicator
                EventCapacityIndicator(event: event),
              ],
            ),
          ),
        ),
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
  final Color iconColor;

  const _InfoRow({
    required this.icon,
    required this.text,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20.r,
          color: iconColor,
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

/// Event Capacity Indicator with animated progress bar
class EventCapacityIndicator extends StatefulWidget {
  final Event event;

  const EventCapacityIndicator({
    super.key,
    required this.event,
  });

  @override
  State<EventCapacityIndicator> createState() => _EventCapacityIndicatorState();
}

class _EventCapacityIndicatorState extends State<EventCapacityIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    final percentage = widget.event.capacity > 0
        ? (widget.event.attendeeCount / widget.event.capacity).clamp(0.0, 1.0)
        : 0.0;

    _animation = Tween<double>(begin: 0.0, end: percentage).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final percentage = widget.event.capacity > 0
        ? (widget.event.attendeeCount / widget.event.capacity).clamp(0.0, 1.0)
        : 0.0;

    final progressColor = widget.event.isFull
        ? AppColors.error
        : percentage > 0.8
            ? AppColors.warning
            : AppColors.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.people,
                  size: 18.r,
                  color: AppColors.textSecondary,
                ),
                SizedBox(width: 6.w),
                Text(
                  'Capacity',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Text(
              '${widget.event.attendeeCount} / ${widget.event.capacity}',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        // Animated Progress Bar
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Stack(
              children: [
                Container(
                  height: 10.h,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: AppColors.border,
                      width: 0.5,
                    ),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: _animation.value,
                  child: Container(
                    height: 10.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          progressColor,
                          progressColor.withAlpha((0.7 * 255).round()),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10.r),
                      boxShadow: [
                        BoxShadow(
                          color: progressColor.withAlpha((0.4 * 255).round()),
                          blurRadius: 8.r,
                          offset: Offset(0, 2.h),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        if (widget.event.remainingSpots > 0 && widget.event.remainingSpots <= 10)
          Padding(
            padding: EdgeInsets.only(top: 6.h),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 14.r,
                  color: AppColors.warning,
                ),
                SizedBox(width: 4.w),
                Text(
                  'Only ${widget.event.remainingSpots} spots left!',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.warning,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          )
              .animate()
              .fadeIn(duration: 600.ms, delay: 400.ms)
              .slideX(begin: -0.2, end: 0),
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

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: AppShadows.small(AppColors.isDarkMode),
      ),
      child: GlassContainer(
        blur: 15,
        opacity: 0.1,
        borderRadius: BorderRadius.circular(16.r),
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
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
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _isExpanded ? 'Show less' : 'Read more',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      size: 18.r,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: AppShadows.small(AppColors.isDarkMode),
      ),
      child: GlassContainer(
        blur: 15,
        opacity: 0.1,
        borderRadius: BorderRadius.circular(16.r),
        padding: EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            // Avatar with gradient background
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withAlpha((0.7 * 255).round()),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withAlpha((0.3 * 255).round()),
                    blurRadius: 8.r,
                    offset: Offset(0, 4.h),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 28.r,
                backgroundColor: Colors.transparent,
                child: Text(
                  initial,
                  style: AppTextStyles.headingSmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
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
                  SizedBox(height: 4.h),
                  Text(
                    displayName,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 24.r,
              color: AppColors.primary,
            ),
          ],
        ),
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

    return ModernButton(
      onPressed: canRegister && !isLoading ? onRegister : null,
      isLoading: isLoading,
      useGradient: true,
      type: ModernButtonType.primary,
      child: Text(
        event.isFull ? 'Event Full' : 'Register Now',
        style: AppTextStyles.bodyLarge.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildViewTicketButton() {
    return ModernButton(
      onPressed: onViewTicket,
      useGradient: true,
      type: ModernButtonType.primary,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.qr_code, size: 24.r, color: Colors.white),
          SizedBox(width: 8.w),
          Text(
            'View Ticket',
            style: AppTextStyles.bodyLarge.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManageButton() {
    return ModernButton(
      onPressed: onManage,
      useGradient: true,
      type: ModernButtonType.primary,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.settings, size: 20.r, color: AppColors.textOnPrimary),
          SizedBox(width: 8.w),
          Text(
            'Manage Event',
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.textOnPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
