import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/providers/auth_provider.dart';
import '../../presentation/screens/placeholder_screen.dart';

// Import our real/placeholder screens once created in the next step
import '../../presentation/screens/splash_screen.dart';
import '../../presentation/screens/welcome_screen.dart';
import '../../presentation/screens/login_screen.dart';
import '../../presentation/screens/otp_screen.dart';
import '../../presentation/screens/register_screen.dart';
import '../../presentation/screens/complete_profile_screen.dart';
import '../../presentation/screens/address_screen.dart';
import '../../presentation/screens/edit_profile_screen.dart';
import '../../presentation/screens/settings_screen.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String otp = '/otp';
  static const String register = '/register';
  static const String completeProfile = '/complete-profile';
  static const String home = '/';
  static const String favorites = '/favorites';
  static const String checkout = '/checkout';
  static const String liveTracking = '/live-tracking';
  static const String success = '/success';
  static const String editProfile = '/edit-profile';
  static const String address = '/address';
  static const String settings = '/settings';
  static const String adminDashboard = '/admin/dashboard';
  static const String adminMenu = '/admin/menu';

  static GoRouter router(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return GoRouter(
      initialLocation: splash,
      redirect: (context, state) {
        final loc = state.uri.path;
        final isAuth = authState.isAuthenticated;

        // Public authentication routes
        final publicRoutes = [splash, welcome, login, otp, register];

        if (!isAuth) {
          if (!publicRoutes.contains(loc)) {
            return login;
          }
        } else {
          // If authenticated, do not allow returning to login/register/otp
          if (loc == login || loc == otp || loc == register || loc == welcome) {
            return home;
          }
        }
        return null;
      },
      routes: [
        GoRoute(
          path: splash,
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: welcome,
          builder: (context, state) => const WelcomeScreen(),
        ),
        GoRoute(
          path: login,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: otp,
          builder: (context, state) => const OtpScreen(),
        ),
        GoRoute(
          path: register,
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: completeProfile,
          builder: (context, state) => const CompleteProfileScreen(),
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
          path: editProfile,
          builder: (context, state) => const EditProfileScreen(),
        ),
        GoRoute(
          path: address,
          builder: (context, state) => const AddressScreen(),
        ),
        GoRoute(
          path: settings,
          builder: (context, state) => const SettingsScreen(),
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
}
