import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/router/app_router.dart';
import '../cubit/events_cubit.dart';
import '../cubit/events_state.dart';
import '../widgets/main_bottom_navigation.dart';
import '../widgets/custom_search_bar.dart';
import '../widgets/event_card.dart';
import '../widgets/skeleton_event_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/error_view.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<EventsCubit>().loadMore();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Discover Events',
          style: AppTextStyles.headingMedium.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.textPrimary,
            size: 24.w,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: CustomSearchBar(
                controller: _searchController,
                hintText: 'Search events...',
                onChanged: (value) {
                  // Debounce search
                  Future.delayed(const Duration(milliseconds: 500), () {
                    if (value == _searchController.text) {
                      context.read<EventsCubit>().search(value);
                    }
                  });
                },
                onFilterTap: () {
                  _showFilterBottomSheet(context);
                },
              ),
            ),
            // Events list
            Expanded(
              child: BlocBuilder<EventsCubit, EventsState>(
                builder: (context, state) {
                  if (state is EventsLoading) {
                    return ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      itemCount: 5,
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

                  if (state is EventsEmpty) {
                    return EmptyState(
                      icon: Icons.event_busy,
                      title: 'No Events Found',
                      message: state.activeFilter.hasActiveFilters
                          ? 'Try adjusting your filters or search terms'
                          : 'No events are available at the moment',
                      actionText: state.activeFilter.hasActiveFilters
                          ? 'Clear Filters'
                          : null,
                      onActionPressed: state.activeFilter.hasActiveFilters
                          ? () => context.read<EventsCubit>().clearFilters()
                          : null,
                    );
                  }

                  if (state is EventsLoaded ||
                      state is EventsLoadingMore ||
                      state is EventsRefreshing) {
                    final events = state is EventsLoaded
                        ? state.events
                        : state is EventsLoadingMore
                            ? state.currentEvents
                            : state is EventsRefreshing
                                ? state.currentEvents
                                : <dynamic>[];

                    return RefreshIndicator(
                      onRefresh: () async {
                        await context.read<EventsCubit>().refresh();
                      },
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                        ),
                        itemCount:
                            events.length + (state is EventsLoadingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index >= events.length) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          final event = events[index];
                          return EventCard(
                            event: event,
                            onTap: () {
                              context.push('${AppRouter.events}/${event.id}');
                            },
                          );
                        },
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const MainBottomNavigation(),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) => BlocProvider.value(
        value: context.read<EventsCubit>(),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: EdgeInsets.only(top: 12.h),
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.borderColor,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              // Header
              Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filters',
                      style: AppTextStyles.headingMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<EventsCubit>().clearFilters();
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Clear All',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Filter options
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Event Type
                      Text(
                        'Event Type',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: AppSpacing.sm),
                      Wrap(
                        spacing: 8.w,
                        children: [
                          'All',
                          'CONFERENCE',
                          'WORKSHOP',
                          'MEETUP',
                          'SEMINAR',
                          'WEBINAR'
                        ]
                            .map((type) => FilterChip(
                                  label: Text(type),
                                  selected: false, // TODO: Connect to state
                                  onSelected: (selected) {
                                    // TODO: Apply filter
                                  },
                                ))
                            .toList(),
                      ),
                      SizedBox(height: AppSpacing.lg),
                      // Show Past Events
                      SwitchListTile(
                        title: Text(
                          'Show Past Events',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        value: false, // TODO: Connect to state
                        onChanged: (value) {
                          // TODO: Apply filter
                        },
                        activeColor: AppColors.primary,
                        contentPadding: EdgeInsets.zero,
                      ),
                      SizedBox(height: AppSpacing.lg),
                    ],
                  ),
                ),
              ),
              // Apply button
              Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'Apply Filters',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
