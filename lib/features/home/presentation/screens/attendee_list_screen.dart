import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../cubit/attendees_cubit.dart';
import '../cubit/attendees_state.dart';

class AttendeeListScreen extends StatelessWidget {
  final String eventId;

  const AttendeeListScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AttendeesCubit>()..load(eventId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Attendees'),
          backgroundColor: AppColors.surface,
          elevation: 0,
        ),
        body: BlocBuilder<AttendeesCubit, AttendeesState>(
          builder: (context, state) {
            if (state is AttendeesLoading || state is AttendeesInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is AttendeesError) {
              return Center(
                child: Text(
                  state.message,
                  style: AppTextStyles.bodyMedium,
                ),
              );
            }
            if (state is AttendeesLoaded) {
              if (state.attendees.isEmpty) {
                return Center(
                  child: Text(
                    'No attendees yet',
                    style: AppTextStyles.bodyMedium,
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: () =>
                    context.read<AttendeesCubit>().refresh(eventId),
                child: ListView.builder(
                  padding: EdgeInsets.all(AppSpacing.md),
                  itemCount: state.attendees.length,
                  itemBuilder: (context, index) {
                    final attendee = state.attendees[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: ListTile(
                        title: Text(attendee.name),
                        subtitle: Text(attendee.email),
                        trailing: Chip(
                          label: Text(attendee.attended ? 'Attended' : 'Pending'),
                          backgroundColor: attendee.attended
                              ? AppColors.success.withOpacity(0.15)
                              : AppColors.warning.withOpacity(0.15),
                          labelStyle: AppTextStyles.bodySmall.copyWith(
                            color: attendee.attended
                                ? AppColors.success
                                : AppColors.warning,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
