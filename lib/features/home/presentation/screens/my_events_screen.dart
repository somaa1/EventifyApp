import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../cubit/my_events_cubit.dart';
import '../cubit/my_events_state.dart';
import '../widgets/main_bottom_navigation.dart';
import '../widgets/my_events_widgets.dart';
import '../widgets/error_view.dart';
import '../../domain/entities/event.dart';

class MyEventsScreen extends StatelessWidget {
  const MyEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<MyEventsCubit>()..loadMyEvents(),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.surface,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: AppColors.textPrimary,
                size: 24.r,
              ),
              onPressed: () => context.pop(),
            ),
            title: Text(
              'My Events',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
            bottom: TabBar(
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.primary,
              indicatorWeight: 2.h,
              labelStyle: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
              ),
              tabs: const [
                Tab(text: 'Upcoming'),
                Tab(text: 'Past'),
              ],
            ),
          ),
          body: BlocBuilder<MyEventsCubit, MyEventsState>(
            builder: (context, state) {
              if (state is MyEventsLoading) {
                return _buildLoadingState();
              } else if (state is MyEventsLoaded) {
                return _buildLoadedState(context, state);
              } else if (state is MyEventsError) {
                return _buildErrorState(context, state.message);
              }
              return const SizedBox.shrink();
            },
          ),
          bottomNavigationBar: const MainBottomNavigation(),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    // Create dummy events for skeleton
    final dummyEvents = List.generate(
      3,
      (index) => Event(
        id: '$index',
        title: 'Loading Event Title Here',
        description: 'Loading description',
        location: 'Loading Location',
        startDateTime: DateTime.now(),
        endDateTime: DateTime.now().add(const Duration(hours: 2)),
        eventType: 'CONFERENCE',
        capacity: 100,
        attendeeCount: 50,
        organizerName: 'Organizer',
        organizerId: '1',
        status: 'UPCOMING',
      ),
    );

    return Skeletonizer(
      enabled: true,
      child: TabBarView(
        children: [
          _buildEventsList(dummyEvents, false),
          _buildEventsList(dummyEvents, true),
        ],
      ),
    );
  }

  Widget _buildLoadedState(BuildContext context, MyEventsLoaded state) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<MyEventsCubit>().refreshMyEvents();
      },
      child: TabBarView(
        children: [
          // Upcoming Events Tab
          state.upcomingEvents.isEmpty
              ? EmptyEventsState(
                  message: 'No upcoming events yet',
                  icon: Icons.event_available_outlined,
                  actionLabel: 'Browse Events',
                  onAction: () {
                    context.push('/events');
                  },
                )
              : _buildEventsList(state.upcomingEvents, false),

          // Past Events Tab
          state.pastEvents.isEmpty
              ? const EmptyEventsState(
                  message: 'No past events',
                  icon: Icons.history_outlined,
                )
              : _buildEventsList(state.pastEvents, true),
        ],
      ),
    );
  }

  Widget _buildEventsList(List<Event> events, bool isPast) {
    return ListView.builder(
      padding: EdgeInsets.all(AppSpacing.md),
      itemCount: events.length,
      itemBuilder: (context, index) {
        return MyEventCard(
          event: events[index],
          isPast: isPast,
        );
      },
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return ErrorView(
      message: message,
      onRetry: () {
        context.read<MyEventsCubit>().loadMyEvents();
      },
    );
  }
}
