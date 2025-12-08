import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';

class MainBottomNavigation extends StatelessWidget {
  const MainBottomNavigation({super.key});

  int _getCurrentIndex(String location) {
    if (location.startsWith(AppRouter.events)) return 1;
    if (location.startsWith(AppRouter.myEvents)) return 2;
    if (location.startsWith(AppRouter.calendar)) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    // GoRouterState provides current uri; use it to derive active tab.
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = _getCurrentIndex(location);

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        switch (index) {
          case 0:
            context.go(AppRouter.home);
            break;
          case 1:
            context.go(AppRouter.events);
            break;
          case 2:
            context.go(AppRouter.myEvents);
            break;
          case 3:
            context.go(AppRouter.calendar);
            break;
        }
      },
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textSecondary,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.event),
          label: 'Events',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark),
          label: 'My Events',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Calendar',
        ),
      ],
    );
  }
}
