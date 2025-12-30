import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/modern_bottom_sheet.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/router/app_router.dart';
import '../../domain/entities/event_filter.dart';
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

  EventFilter _getActiveFilter(EventsState state) {
    if (state is EventsLoaded) return state.activeFilter;
    if (state is EventsLoadingMore) return state.activeFilter;
    if (state is EventsEmpty) return state.activeFilter;
    return EventFilter.empty;
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
                          ? 'No events match your filters.\nTry adjusting your search or filters.'
                          : 'No events are currently available.\nCheck back later!',
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
    showModernBottomSheet(
      context: context,
      useGlass: true,
      title: 'Filters',
      height: MediaQuery.of(context).size.height * 0.7,
      child: BlocProvider.value(
        value: context.read<EventsCubit>(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Clear all button
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
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
            ),
            // Filter options
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event Type
                Text(
                  'Event Type',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: AppSpacing.sm),
                BlocBuilder<EventsCubit, EventsState>(
                  builder: (context, state) {
                    final activeFilter = _getActiveFilter(state);
                    final selectedType = activeFilter.eventType;

                    return Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: [
                        'All',
                        'CONFERENCE',
                        'WORKSHOP',
                        'MEETUP',
                        'SEMINAR',
                        'WEBINAR'
                      ]
                          .map((type) => GlassContainer(
                                blur: 10,
                                opacity: (type == 'All'
                                        ? selectedType == null
                                        : selectedType == type)
                                    ? 0.15
                                    : 0.05,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 10.h,
                                ),
                                borderRadius: BorderRadius.circular(20.r),
                                child: InkWell(
                                  onTap: () {
                                    final newType = type == 'All' ? null : type;
                                    final newFilter =
                                        activeFilter.copyWith(eventType: newType);
                                    context
                                        .read<EventsCubit>()
                                        .applyFilter(newFilter);
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    type,
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: (type == 'All'
                                              ? selectedType == null
                                              : selectedType == type)
                                          ? AppColors.primary
                                          : AppColors.textSecondary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ))
                          .toList(),
                    );
                  },
                ),
                SizedBox(height: AppSpacing.lg),
                // Show Past Events
                GlassContainer(
                  blur: 10,
                  opacity: 0.05,
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xs,
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                  child: BlocBuilder<EventsCubit, EventsState>(
                    builder: (context, state) {
                      final activeFilter = _getActiveFilter(state);

                      return SwitchListTile(
                        title: Text(
                          'Show Past Events',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        value: activeFilter.showPastEvents,
                        onChanged: (value) {
                          final newFilter =
                              activeFilter.copyWith(showPastEvents: value);
                          context.read<EventsCubit>().applyFilter(newFilter);
                        },
                        activeTrackColor:
                            AppColors.primary.withAlpha((0.5 * 255).round()),
                        thumbColor: WidgetStateProperty.resolveWith((states) =>
                            states.contains(WidgetState.selected)
                                ? AppColors.primary
                                : AppColors.textDisabled),
                        contentPadding: EdgeInsets.zero,
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
