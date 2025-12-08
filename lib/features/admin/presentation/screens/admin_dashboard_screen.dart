import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../home/presentation/cubit/home_cubit.dart';
import '../../../home/presentation/cubit/home_state.dart';
import '../../../home/presentation/widgets/skeleton_stat_card.dart';
import '../../../home/presentation/widgets/stat_card.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HomeCubit>()..loadHomeData(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Dashboard'),
          backgroundColor: AppColors.surface,
          elevation: 0,
        ),
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: AppSpacing.md,
                  crossAxisSpacing: AppSpacing.md,
                  childAspectRatio: 1.3,
                  children: List.generate(4, (_) => const SkeletonStatCard()),
                ),
              );
            }
            if (state is HomeLoaded) {
              final stats = state.stats;
              return Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Overview',
                      style: AppTextStyles.headingSmall.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: AppSpacing.md),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: AppSpacing.md,
                      crossAxisSpacing: AppSpacing.md,
                      childAspectRatio: 1.3,
                      children: [
                        StatCard(
                          title: 'Total Users',
                          value: '${stats.totalUsers ?? 0}',
                          icon: Icons.people,
                          iconColor: AppColors.primary,
                        ),
                        StatCard(
                          title: 'Total Events',
                          value: '${stats.eventsCreated}',
                          icon: Icons.event,
                          iconColor: AppColors.success,
                        ),
                        StatCard(
                          title: 'Upcoming',
                          value: '${stats.upcomingEvents}',
                          icon: Icons.calendar_today,
                          iconColor: AppColors.warning,
                        ),
                        StatCard(
                          title: 'Attendees',
                          value: '${stats.totalAttendees}',
                          icon: Icons.groups,
                          iconColor: AppColors.secondary,
                        ),
                      ],
                    ),
                  ],
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
