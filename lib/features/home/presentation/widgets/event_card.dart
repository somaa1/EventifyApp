import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../domain/entities/event.dart';

/// Modern card widget for displaying event information with glassmorphism
class EventCard extends StatefulWidget {
  final Event event;
  final VoidCallback? onTap;

  const EventCard({
    super.key,
    required this.event,
    this.onTap,
  });

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap?.call();
      },
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
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image with gradient overlay
              if (widget.event.imageUrl != null)
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.r),
                        topRight: Radius.circular(16.r),
                      ),
                      child: Hero(
                        tag: 'event-${widget.event.id}',
                        child: Image.network(
                          widget.event.imageUrl!,
                          height: 180.h,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildPlaceholder();
                          },
                        ),
                      ),
                    ),
                    // Gradient overlay for better badge visibility
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 80.h,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withAlpha((0.3 * 255).round()),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Event type badge on image
                    Positioned(
                      top: AppSpacing.sm,
                      left: AppSpacing.sm,
                      child: _buildEventTypeBadge(),
                    ),
                  ],
                )
              else
                _buildPlaceholder(),

              // Content
              Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      widget.event.title,
                      style: AppTextStyles.headingSmall.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: AppSpacing.sm),
                    // Date and time
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 16.w,
                          color: AppColors.primary,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          DateFormat('MMM dd, yyyy • HH:mm')
                              .format(widget.event.startDateTime),
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.xs),
                    // Location
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16.w,
                          color: AppColors.secondary,
                        ),
                        SizedBox(width: 6.w),
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
                      ],
                    ),
                    SizedBox(height: AppSpacing.sm),
                    // Footer: Attendees and status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.people,
                              size: 16.w,
                              color: AppColors.textSecondary,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              '${widget.event.attendeeCount}/${widget.event.capacity}',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        if (widget.event.isFull)
                          GlassContainer(
                            blur: 10,
                            opacity: 0.15,
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 5.h,
                            ),
                            borderRadius: BorderRadius.circular(20.r),
                            child: Text(
                              'Full',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.error,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate(target: _isPressed ? 1 : 0)
        .scale(begin: const Offset(1, 1), end: const Offset(0.97, 0.97));
  }

  Widget _buildPlaceholder() {
    return Stack(
      children: [
        Container(
          height: 180.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary.withAlpha((0.15 * 255).round()),
                AppColors.secondary.withAlpha((0.15 * 255).round()),
              ],
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
            ),
          ),
          child: Center(
            child: Icon(
              Icons.event,
              size: 64.w,
              color: AppColors.primary.withAlpha((0.4 * 255).round()),
            ),
          ),
        ),
        Positioned(
          top: AppSpacing.sm,
          left: AppSpacing.sm,
          child: _buildEventTypeBadge(),
        ),
      ],
    );
  }

  Widget _buildEventTypeBadge() {
    Color badgeColor;
    switch (widget.event.eventType.toUpperCase()) {
      case 'CONFERENCE':
        badgeColor = AppColors.primary;
        break;
      case 'WORKSHOP':
        badgeColor = AppColors.success;
        break;
      case 'MEETUP':
        badgeColor = AppColors.warning;
        break;
      default:
        badgeColor = AppColors.textSecondary;
    }

    return GlassContainer(
      blur: 15,
      opacity: 0.2,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      borderRadius: BorderRadius.circular(20.r),
      gradient: LinearGradient(
        colors: [
          badgeColor.withAlpha((0.3 * 255).round()),
          badgeColor.withAlpha((0.2 * 255).round()),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.r,
            height: 6.r,
            decoration: BoxDecoration(
              color: badgeColor,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 6.w),
          Text(
            widget.event.eventType,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.isDarkMode ? AppColors.textPrimary : badgeColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
