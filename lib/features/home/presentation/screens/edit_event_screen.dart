import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
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

            showDialog(
              context: context,
              builder: (dialogContext) => AlertDialog(
                title: Row(
                  children: [
                    Icon(
                      isNetworkError ? Icons.wifi_off : Icons.error_outline,
                      color: AppColors.error,
                    ),
                    SizedBox(width: 8.w),
                    const Text('Update Failed'),
                  ],
                ),
                content: Text(errorMessage),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: const Text('Close'),
                  ),
                  if (isServerError)
                    TextButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                        _submit(context);
                      },
                      child: const Text('Retry'),
                    ),
                ],
              ),
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
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
                  ),
                  SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _descriptionController,
                    minLines: 3,
                    maxLines: 5,
                    decoration: const InputDecoration(labelText: 'Description'),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
                  ),
                  SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _locationController,
                    decoration: const InputDecoration(labelText: 'Location'),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
                  ),
                  SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _pickDate(isStart: true),
                          child: Text(
                            'Start: ${_startDate.toLocal()}',
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ),
                      ),
                      SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _pickDate(isStart: false),
                          child: Text(
                            'End: ${_endDate.toLocal()}',
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.md),
                  DropdownButtonFormField<String>(
                    value: _eventType,
                    items: const [
                      DropdownMenuItem(
                        value: 'PUBLIC',
                        child: Text('Public'),
                      ),
                      DropdownMenuItem(
                        value: 'PRIVATE',
                        child: Text('Private'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _eventType = value);
                      }
                    },
                    decoration:
                        const InputDecoration(labelText: 'Visibility'),
                  ),
                  SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _capacityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Capacity'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      final parsed = int.tryParse(value);
                      if (parsed == null || parsed <= 0) {
                        return 'Enter a valid number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: AppSpacing.lg),
                  BlocBuilder<CreateEventCubit, CreateEventState>(
                    builder: (context, state) {
                      final isLoading = state is CreateEventSubmitting;
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:
                              isLoading ? null : () => _submit(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding:
                                EdgeInsets.symmetric(vertical: AppSpacing.md),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor:
                                        AlwaysStoppedAnimation(Colors.white),
                                  ),
                                )
                              : Text(
                                  'Save Changes',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
