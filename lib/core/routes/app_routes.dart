import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/screens/placeholder_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String otp = '/otp';
  static const String home = '/';
  static const String favorites = '/favorites';
  static const String checkout = '/checkout';
  static const String liveTracking = '/live-tracking';
  static const String success = '/success';
  static const String adminDashboard = '/admin/dashboard';
  static const String adminMenu = '/admin/menu';

  static final GoRouter router = GoRouter(
    initialLocation: login,
    routes: [
      GoRoute(
        path: login,
        builder: (context, state) => const PlaceholderScreen(title: 'Customer Login'),
      ),
      GoRoute(
        path: otp,
        builder: (context, state) => const PlaceholderScreen(title: 'OTP Verification'),
      ),
      GoRoute(
        path: home,
        builder: (context, state) => const PlaceholderScreen(title: 'Home Portal'),
      ),
      GoRoute(
        path: favorites,
        builder: (context, state) => const PlaceholderScreen(title: 'Favorites'),
      ),
      GoRoute(
        path: checkout,
        builder: (context, state) => const PlaceholderScreen(title: 'Checkout'),
      ),
      GoRoute(
        path: liveTracking,
        builder: (context, state) => const PlaceholderScreen(title: 'Live Tracking'),
      ),
      GoRoute(
        path: success,
        builder: (context, state) => const PlaceholderScreen(title: 'Order Success'),
      ),
      GoRoute(
        path: adminDashboard,
        builder: (context, state) => const PlaceholderScreen(title: 'Admin Dashboard'),
      ),
      GoRoute(
        path: adminMenu,
        builder: (context, state) => const PlaceholderScreen(title: 'Admin Menu Management'),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.error}'),
      ),
    ),
  );
}
