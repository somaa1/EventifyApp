import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../home/presentation/cubit/events_cubit.dart';
import '../../../home/presentation/cubit/events_state.dart';
import '../../../home/presentation/widgets/event_card.dart';
import '../../../home/presentation/widgets/skeleton_event_card.dart';
import '../../../home/presentation/widgets/error_view.dart';

class AdminEventsScreen extends StatelessWidget {
  const AdminEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<EventsCubit>()..loadEvents(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('All Events'),
          backgroundColor: AppColors.surface,
          elevation: 0,
        ),
        body: BlocBuilder<EventsCubit, EventsState>(
          builder: (context, state) {
            if (state is EventsLoading) {
              return ListView.builder(
                padding: EdgeInsets.all(AppSpacing.lg),
                itemCount: 4,
                itemBuilder: (context, index) =>
                    const SkeletonEventCard(),
              );
            }
            if (state is EventsError && state.currentEvents == null) {
              return ErrorView(
                message: state.message,
                onRetry: () => context.read<EventsCubit>().loadEvents(),
              );
            }
            if (state is EventsLoaded) {
              return ListView.builder(
                padding: EdgeInsets.all(AppSpacing.lg),
                itemCount: state.events.length,
                itemBuilder: (context, index) {
                  final event = state.events[index];
                  return Column(
                    children: [
                      EventCard(event: event, onTap: () {}),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => _showNotImplemented(context),
                            child: const Text('Approve'),
                          ),
                          TextButton(
                            onPressed: () => _showNotImplemented(context),
                            child: const Text('Reject'),
                          ),
                        ],
                      )
                    ],
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  void _showNotImplemented(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Action not implemented in demo build'),
      ),
    );
  }
}
