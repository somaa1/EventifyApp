import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/permission_helper.dart';
import '../cubit/attendance_cubit.dart';
import '../cubit/attendance_state.dart';
import '../widgets/attendance_confirmation_dialog.dart';
import '../widgets/scanner_overlay.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  bool _isHandlingCode = false;
  late final MobileScannerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkPermission());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _checkPermission() async {
    final hasPermission = await PermissionHelper.requestCameraPermission();
    if (!hasPermission && mounted) {
      await PermissionHelper.showPermissionDialog(context);
      if (mounted) Navigator.pop(context);
    }
  }

  void _handleScannedCode(BuildContext context, String code) {
    if (_isHandlingCode) return;
    _isHandlingCode = true;
    showDialog(
      context: context,
      builder: (_) => AttendanceConfirmationDialog(
        token: code,
        onConfirm: () {
          context.read<AttendanceCubit>().confirmAttendance(code);
        },
      ),
    ).whenComplete(() {
      _isHandlingCode = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AttendanceCubit>(),
      child: BlocListener<AttendanceCubit, AttendanceState>(
        listener: (context, state) {
          if (state is AttendanceSuccess) {
            context.go(AppRouter.attendanceSuccess, extra: state.attendance);
          } else if (state is AttendanceError) {
            context.go(AppRouter.attendanceError, extra: state.message);
          }
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
            title: Text(
              'Scan Ticket',
              style: AppTextStyles.headingSmall.copyWith(color: Colors.white),
            ),
          ),
          body: Stack(
            fit: StackFit.expand,
            children: [
              MobileScanner(
                controller: _controller,
                onDetect: (capture) {
                  for (final barcode in capture.barcodes) {
                    final raw = barcode.rawValue;
                    if (raw != null) {
                      _handleScannedCode(context, raw);
                      break;
                    }
                  }
                },
              ),
              const ScannerOverlay(),
              Positioned(
                bottom: 20.h,
                right: 20.w,
                child: IconButton(
                  onPressed: () => _controller.toggleTorch(),
                  icon: ValueListenableBuilder<MobileScannerState>(
                      valueListenable: _controller,
                      builder: (context, state, _) {
                        final isOn = state.torchState == TorchState.on;
                        return Icon(
                          isOn ? Icons.flash_on : Icons.flash_off,
                          color: isOn ? AppColors.warning : Colors.white,
                          size: 28.w,
                        );
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
