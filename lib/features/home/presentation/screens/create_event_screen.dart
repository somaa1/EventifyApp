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
import '../cubit/create_event_cubit.dart';
import '../cubit/create_event_state.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _capacityController = TextEditingController();
  // Backend expects visibility enum (PUBLIC/PRIVATE); default to PUBLIC
  String _eventType = 'PUBLIC';
  DateTime? _startDate;
  DateTime? _endDate;

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
      'startDateTime': _startDate?.toIso8601String(),
      'endDateTime': _endDate?.toIso8601String(),
      'eventType': _eventType,
      'capacity': int.tryParse(_capacityController.text.trim()) ?? 0,
    };
  }

  Future<void> _pickDate({
    required bool isStart,
  }) async {
    final now = DateTime.now();
    final initial = isStart ? _startDate ?? now : _endDate ?? now;
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: now,
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
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select start and end date/time')),
      );
      return;
    }
    if (_endDate!.isBefore(_startDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('End date must be after start date')),
      );
      return;
    }
    context.read<CreateEventCubit>().createEvent(_buildPayload());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CreateEventCubit>(),
      child: BlocListener<CreateEventCubit, CreateEventState>(
        listener: (context, state) {
          if (state is CreateEventSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Event saved successfully')),
            );
            context.pop();
          } else if (state is CreateEventError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Create Event'),
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
                            Icon(Icons.add_circle_outline, size: 20.r, color: AppColors.textOnPrimary),
                            SizedBox(width: 8.w),
                            Text(
                              'Create Event',
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
    required DateTime? dateTime,
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
                dateTime == null
                    ? 'Not selected'
                    : DateFormat('MMM dd, yyyy • HH:mm').format(dateTime),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: dateTime == null ? AppColors.textSecondary : AppColors.textPrimary,
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
