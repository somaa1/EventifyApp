import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';

class ScannerOverlay extends StatelessWidget {
  const ScannerOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 2.w,
              ),
            ),
          ),
        ),
        Center(
          child: Container(
            width: 240.w,
            height: 240.w,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.primary,
                width: 4.w,
              ),
              borderRadius: BorderRadius.circular(16.r),
              color: Colors.black.withOpacity(0.1),
            ),
          ),
        ),
        Positioned(
          bottom: 32.h,
          left: 0,
          right: 0,
          child: Text(
            'Align the QR code within the frame to scan',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
