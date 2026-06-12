import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  const AppBottomNav({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      backgroundColor: Colors.white,
      indicatorColor: AppTheme.forestGreen.withOpacity(0.12),
      onDestinationSelected: (i) {
        switch (i) {
          case 0: context.go('/home'); break;
          case 1: context.go('/favorites'); break;
          case 2: context.go('/my-bookings'); break;
          case 3: context.go('/profile'); break;
        }
      },
      destinations: const [
        NavigationDestination(icon: Icon(Icons.explore_outlined), selectedIcon: Icon(Icons.explore, color: AppTheme.forestGreen), label: 'Explore'),
        NavigationDestination(icon: Icon(Icons.favorite_outline), selectedIcon: Icon(Icons.favorite, color: AppTheme.forestGreen), label: 'Saved'),
        NavigationDestination(icon: Icon(Icons.book_outlined), selectedIcon: Icon(Icons.book, color: AppTheme.forestGreen), label: 'Trips'),
        NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person, color: AppTheme.forestGreen), label: 'Profile'),
      ],
    );
  }
}
