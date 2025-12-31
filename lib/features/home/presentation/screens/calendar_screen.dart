import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../cubit/calendar_cubit.dart';
import '../cubit/calendar_state.dart';
import '../widgets/main_bottom_navigation.dart';
import '../widgets/calendar_widgets.dart';
import '../widgets/error_view.dart';
import '../../domain/entities/event.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CalendarCubit>()..loadEvents(),
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
            'Event Calendar',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<CalendarCubit, CalendarState>(
          builder: (context, state) {
            if (state is CalendarLoading) {
              return _buildLoadingState(context);
            } else if (state is CalendarLoaded) {
              return _buildLoadedState(context, state);
            } else if (state is CalendarError) {
              return _buildErrorState(context, state.message);
            }
            return const SizedBox.shrink();
          },
        ),
        bottomNavigationBar: const MainBottomNavigation(),
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    final now = DateTime.now();
    final dummyEvents = List.generate(
      2,
      (index) => Event(
        id: '$index',
        title: 'Loading Event Title',
        description: 'Loading',
        location: 'Loading Location',
        startDateTime: now,
        endDateTime: now.add(const Duration(hours: 2)),
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
      child: Column(
        children: [
          _buildCalendar(now, now, [], context),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(AppSpacing.md),
              itemCount: dummyEvents.length,
              itemBuilder: (context, index) {
                return CalendarEventItem(event: dummyEvents[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadedState(BuildContext context, CalendarLoaded state) {
    final selectedEvents = state.getEventsForDay(state.selectedDay);

    return RefreshIndicator(
      onRefresh: () async {
        await context.read<CalendarCubit>().refreshEvents();
      },
      child: Column(
        children: [
          // Calendar
          _buildCalendar(
            state.selectedDay,
            state.focusedDay,
            state.events,
            context,
          ),

          // Divider
          Divider(
            height: 1.h,
            color: AppColors.divider,
          ),

          // Events for selected day
          Expanded(
            child: selectedEvents.isEmpty
                ? NoEventsOnDay(day: state.selectedDay)
                : ListView.builder(
                    padding: EdgeInsets.all(AppSpacing.md),
                    itemCount: selectedEvents.length,
                    itemBuilder: (context, index) {
                      return CalendarEventItem(event: selectedEvents[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar(
    DateTime selectedDay,
    DateTime focusedDay,
    List<Event> events,
    BuildContext context,
  ) {
    return Container(
      color: AppColors.surface,
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: focusedDay,
        selectedDayPredicate: (day) => isSameDay(selectedDay, day),
        eventLoader: (day) {
          return events.where((event) {
            final eventDate = DateTime(
              event.startDateTime.year,
              event.startDateTime.month,
              event.startDateTime.day,
            );
            final checkDate = DateTime(day.year, day.month, day.day);
            return eventDate == checkDate;
          }).toList();
        },
        onDaySelected: (selectedDay, focusedDay) {
          context.read<CalendarCubit>().selectDay(selectedDay, focusedDay);
        },
        calendarStyle: CalendarStyle(
          // Today
          todayDecoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          todayTextStyle: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
          ),

          // Selected day
          selectedDecoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          selectedTextStyle: TextStyle(
            color: AppColors.textOnPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
          ),

          // Default days
          defaultTextStyle: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14.sp,
          ),

          // Weekend days
          weekendTextStyle: TextStyle(
            color: AppColors.error.withOpacity(0.7),
            fontSize: 14.sp,
          ),

          // Outside days (other months)
          outsideTextStyle: TextStyle(
            color: AppColors.textDisabled,
            fontSize: 14.sp,
          ),

          // Markers
          markerDecoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          markerSize: 6.r,
          markersMaxCount: 3,
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
          leftChevronIcon: Icon(
            Icons.chevron_left,
            color: AppColors.textPrimary,
            size: 24.r,
          ),
          rightChevronIcon: Icon(
            Icons.chevron_right,
            color: AppColors.textPrimary,
            size: 24.r,
          ),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
          weekendStyle: TextStyle(
            color: AppColors.error.withOpacity(0.7),
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, date, events) {
            if (events.isEmpty) return const SizedBox.shrink();
            return EventMarker(count: events.length);
          },
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return ErrorView(
      message: message,
      onRetry: () {
        context.read<CalendarCubit>().loadEvents();
      },
    );
  }
}
