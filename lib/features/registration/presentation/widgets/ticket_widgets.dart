import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/registration.dart';
import '../../../home/domain/entities/event.dart';

/// Main ticket card with QR code and event details
class TicketCard extends StatelessWidget {
  final Registration registration;
  final Event event;

  const TicketCard({
    super.key,
    required this.registration,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        children: [
          // Ticket Header
          _buildTicketHeader(),

          // QR Code Section
          _buildQRSection(),

          // Divider with perforation effect
          _buildDivider(),

          // Ticket Details
          _buildTicketDetails(),
        ],
      ),
    );
  }

  Widget _buildTicketHeader() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.confirmation_number_outlined,
                color: Colors.white,
                size: 24.r,
              ),
              SizedBox(width: AppSpacing.sm),
              Text(
                'Event Ticket',
                style: AppTextStyles.textTheme.titleMedium!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            event.title,
            style: AppTextStyles.textTheme.headlineSmall!.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQRSection() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.xl),
      child: Column(
        children: [
          // QR Code
          Container(
            padding: EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: AppColors.divider,
                width: 1,
              ),
            ),
            child: QrImageView(
              data: registration.registrationToken,
              version: QrVersions.auto,
              size: 200.w,
              backgroundColor: Colors.white,
              errorCorrectionLevel: QrErrorCorrectLevel.H,
            ),
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            'Scan this QR code at the event',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            'Token: ${registration.registrationToken.substring(0, 8)}...',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textDisabled,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Stack(
      children: [
        Container(
          height: 1.h,
          color: AppColors.divider,
        ),
        Positioned(
          left: 0,
          top: -10.h,
          child: Container(
            width: 20.w,
            height: 20.h,
            decoration: BoxDecoration(
              color: AppColors.background,
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          right: 0,
          top: -10.h,
          child: Container(
            width: 20.w,
            height: 20.h,
            decoration: BoxDecoration(
              color: AppColors.background,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTicketDetails() {
    return Padding(
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          _TicketInfoRow(
            icon: Icons.calendar_today_outlined,
            label: 'Date',
            value: DateFormat('MMM dd, yyyy').format(event.startDateTime),
          ),
          SizedBox(height: AppSpacing.md),
          _TicketInfoRow(
            icon: Icons.access_time_outlined,
            label: 'Time',
            value: DateFormat('hh:mm a').format(event.startDateTime),
          ),
          SizedBox(height: AppSpacing.md),
          _TicketInfoRow(
            icon: Icons.location_on_outlined,
            label: 'Location',
            value: event.location,
          ),
          SizedBox(height: AppSpacing.md),
          _TicketInfoRow(
            icon: Icons.category_outlined,
            label: 'Event Type',
            value: _formatEventType(event.eventType),
          ),
          SizedBox(height: AppSpacing.md),
          _TicketInfoRow(
            icon: Icons.confirmation_number_outlined,
            label: 'Registered',
            value: DateFormat('MMM dd, yyyy').format(registration.registeredAt),
          ),
        ],
      ),
    );
  }

  String _formatEventType(String type) {
    return type.split('_').map((word) {
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }
}

/// Ticket information row widget
class _TicketInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _TicketInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            icon,
            size: 20.r,
            color: AppColors.primary,
          ),
        ),
        SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                value,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Important notice card
class ImportantNoticeCard extends StatelessWidget {
  const ImportantNoticeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.md),
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.warning.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            color: AppColors.warning,
            size: 20.r,
          ),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Important',
                  style: AppTextStyles.textTheme.titleSmall!.copyWith(
                    color: AppColors.warning,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Please present this QR code at the event entrance. Screenshots are not valid.',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Action buttons for the ticket screen
class TicketActionButtons extends StatelessWidget {
  final VoidCallback onShare;
  final VoidCallback onAddToCalendar;

  const TicketActionButtons({
    super.key,
    required this.onShare,
    required this.onAddToCalendar,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onShare,
              icon: Icon(Icons.share_outlined, size: 20.r),
              label: Text('Share'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: BorderSide(color: AppColors.primary),
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onAddToCalendar,
              icon: Icon(Icons.calendar_today_outlined, size: 20.r),
              label: Text('Add to Calendar'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: BorderSide(color: AppColors.primary),
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
