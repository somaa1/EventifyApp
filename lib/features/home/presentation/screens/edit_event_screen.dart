import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/widgets/modern_text_field.dart';
import '../../../../core/widgets/modern_button.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/modern_dialog.dart';
import '../../domain/entities/event.dart';
import '../cubit/create_event_cubit.dart';
import '../cubit/create_event_state.dart';

class EditEventScreen extends StatefulWidget {
  final Event event;

  const EditEventScreen({super.key, required this.event});

  @override
  State<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  late TextEditingController _capacityController;
  late String _eventType;
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.event.title);
    _descriptionController =
        TextEditingController(text: widget.event.description);
    _locationController = TextEditingController(text: widget.event.location);
    _capacityController =
        TextEditingController(text: widget.event.capacity.toString());
    // Fallback to PUBLIC if the stored value isn't supported by backend
    _eventType = const ['PUBLIC', 'PRIVATE'].contains(
            widget.event.eventType.toUpperCase())
        ? widget.event.eventType.toUpperCase()
        : 'PUBLIC';
    _startDate = widget.event.startDateTime;
    _endDate = widget.event.endDateTime;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _capacityController.dispose();
    super.dispose();
  }

  Map<String, dynamic> _buildPayload() {
    return {
      'title': _titleController.text.trim(),
      'description': _descriptionController.text.trim(),
      'location': _locationController.text.trim(),
      'startDateTime': _startDate.toIso8601String(),
      'endDateTime': _endDate.toIso8601String(),
      'eventType': _eventType,
      'capacity': int.tryParse(_capacityController.text.trim()) ?? 0,
    };
  }

  Future<void> _pickDate({required bool isStart}) async {
    final now = DateTime.now();
    final initial = isStart ? _startDate : _endDate;
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: now.subtract(const Duration(days: 1)),
      lastDate: DateTime(now.year + 2),
    );
    if (pickedDate == null) return;
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (pickedTime == null) return;
    final combined = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
    setState(() {
      if (isStart) {
        _startDate = combined;
      } else {
        _endDate = combined;
      }
    });
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    if (_endDate.isBefore(_startDate)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('End date must be after start date')),
      );
      return;
    }
    context
        .read<CreateEventCubit>()
        .updateEvent(widget.event.id, _buildPayload());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CreateEventCubit>(),
      child: BlocListener<CreateEventCubit, CreateEventState>(
        listener: (context, state) {
          if (state is CreateEventSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Event updated successfully!'),
                backgroundColor: AppColors.success,
              ),
            );
            context.pop();
          } else if (state is CreateEventError) {
            // Improved error handling
            String errorMessage = state.message;
            bool isServerError = false;
            bool isNetworkError = false;

            if (errorMessage.contains('500') ||
                errorMessage.contains('Internal Server Error')) {
              isServerError = true;
              errorMessage =
                  'Server error: Unable to update event.\n\nThis is a backend issue. The server returned a 500 error.\n\nPlease:\n• Try again in a few minutes\n• Check if other events can be edited\n• Contact support if the issue persists';
            } else if (errorMessage.contains('Network') ||
                errorMessage.contains('connection')) {
              isNetworkError = true;
              errorMessage =
                  'No internet connection. Please check your network and try again.';
            }

            showModernDialog(
              context: context,
              useGlass: true,
              title: 'Update Failed',
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isNetworkError ? Icons.wifi_off : Icons.error_outline,
                    color: AppColors.error,
                    size: 48.r,
                  ),
                  SizedBox(height: AppSpacing.md),
                  Text(
                    errorMessage,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Close',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
                if (isServerError)
                  ModernButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _submit(context);
                    },
                    type: ModernButtonType.primary,
                    child: const Text('Retry'),
                  ),
              ],
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Edit Event'),
            backgroundColor: AppColors.surface,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ModernTextField(
                    controller: _titleController,
                    label: 'Event Title',
                    hint: 'Enter event title',
                    prefixIcon: Icon(Icons.event, color: AppColors.primary),
                    useGlass: true,
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Title is required' : null,
                  ),
                  SizedBox(height: AppSpacing.md),
                  ModernTextField(
                    controller: _descriptionController,
                    label: 'Description',
                    hint: 'Enter event description',
                    prefixIcon: Icon(Icons.description, color: AppColors.primary),
                    useGlass: true,
                    maxLines: 5,
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Description is required' : null,
                  ),
                  SizedBox(height: AppSpacing.md),
                  ModernTextField(
                    controller: _locationController,
                    label: 'Location',
                    hint: 'Enter event location',
                    prefixIcon: Icon(Icons.location_on, color: AppColors.secondary),
                    useGlass: true,
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Location is required' : null,
                  ),
                  SizedBox(height: AppSpacing.md),
                  // Date Time Pickers
                  Row(
                    children: [
                      Expanded(
                        child: _buildDateTimePicker(
                          label: 'Start Date & Time',
                          dateTime: _startDate,
                          icon: Icons.calendar_today,
                          onTap: () => _pickDate(isStart: true),
                        ),
                      ),
                      SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: _buildDateTimePicker(
                          label: 'End Date & Time',
                          dateTime: _endDate,
                          icon: Icons.event,
                          onTap: () => _pickDate(isStart: false),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.md),
                  // Visibility Dropdown
                  DropdownButtonFormField<String>(
                    value: _eventType,
                    items: [
                      DropdownMenuItem(
                        value: 'PUBLIC',
                        child: Text('Public', style: AppTextStyles.bodyMedium),
                      ),
                      DropdownMenuItem(
                        value: 'PRIVATE',
                        child: Text('Private', style: AppTextStyles.bodyMedium),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _eventType = value);
                      }
                    },
                    icon: Icon(Icons.arrow_drop_down, color: AppColors.primary),
                    dropdownColor: AppColors.surface,
                    style: AppTextStyles.bodyMedium,
                    decoration: InputDecoration(
                      labelText: 'Event Visibility',
                      prefixIcon: Icon(
                        _eventType == 'PUBLIC' ? Icons.public : Icons.lock,
                        color: _eventType == 'PUBLIC' ? AppColors.primary : AppColors.secondary,
                      ),
                      filled: true,
                      fillColor: AppColors.surfaceVariant.withOpacity(0.5),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.md,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                        borderSide: BorderSide(
                          color: AppColors.border,
                          width: 1.w,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                        borderSide: BorderSide(
                          color: AppColors.border,
                          width: 1.w,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                        borderSide: BorderSide(
                          color: AppColors.primary,
                          width: 2.w,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: AppSpacing.md),
                  ModernTextField(
                    controller: _capacityController,
                    label: 'Capacity',
                    hint: 'Enter maximum attendees',
                    prefixIcon: Icon(Icons.people, color: AppColors.primary),
                    useGlass: true,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Capacity is required';
                      }
                      final parsed = int.tryParse(value);
                      if (parsed == null || parsed <= 0) {
                        return 'Enter a valid number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: AppSpacing.xl),
                  // Submit Button
                  BlocBuilder<CreateEventCubit, CreateEventState>(
                    builder: (context, state) {
                      final isLoading = state is CreateEventSubmitting;
                      return ModernButton(
                        onPressed: isLoading ? null : () => _submit(context),
                        isLoading: isLoading,
                        useGradient: true,
                        type: ModernButtonType.primary,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.save, size: 20.r, color: AppColors.textOnPrimary),
                            SizedBox(width: 8.w),
                            Text(
                              'Save Changes',
                              style: AppTextStyles.bodyLarge.copyWith(
                                color: AppColors.textOnPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimePicker({
    required String label,
    required DateTime dateTime,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
              Row(
                children: [
                  Icon(icon, size: 18.r, color: AppColors.primary),
                  SizedBox(width: 6.w),
                  Text(
                    label,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                DateFormat('MMM dd, yyyy • HH:mm').format(dateTime),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
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
