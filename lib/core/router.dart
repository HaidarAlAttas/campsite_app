import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_state.dart';
import '../ui/pages/splash_page.dart';
import '../ui/pages/login_page.dart';
import '../ui/pages/home_page.dart';
import '../ui/pages/campsite_detail_page.dart';
import '../ui/pages/booking_page.dart';
import '../ui/pages/booking_confirm_page.dart';
import '../ui/pages/favorites_page.dart';
import '../ui/pages/my_bookings_page.dart';
import '../ui/pages/profile_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createRouter(AuthBloc authBloc) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    redirect: (context, state) {
      final authState = authBloc.state;
      final isLoggedIn = authState is AuthAuthenticated;
      final isLoggingIn = state.matchedLocation == '/login';
      final isSplash = state.matchedLocation == '/';

      if (isSplash) return null;
      if (!isLoggedIn && !isLoggingIn) return '/login';
      if (isLoggedIn && isLoggingIn) return '/home';
      return null;
    },
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    routes: [
      GoRoute(path: '/', builder: (_, __) => const SplashPage()),
      GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
      GoRoute(path: '/home', builder: (_, __) => const HomePage()),
      GoRoute(
        path: '/campsite/:id',
        builder: (_, state) =>
            CampsiteDetailPage(id: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/book/:id',
        builder: (_, state) =>
            BookingPage(campsiteId: state.pathParameters['id']!),
      ),
      GoRoute(
          path: '/booking/confirm',
          builder: (_, __) => const BookingConfirmPage()),
      GoRoute(path: '/favorites', builder: (_, __) => const FavoritesPage()),
      GoRoute(path: '/my-bookings', builder: (_, __) => const MyBookingsPage()),
      GoRoute(path: '/profile', builder: (_, __) => const ProfilePage()),
    ],
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;

  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
