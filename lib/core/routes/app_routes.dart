import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/product_entity.dart';
import '../../presentation/providers/auth_provider.dart';
import '../../presentation/screens/placeholder_screen.dart';

// Import our real customer screens
import '../../presentation/screens/splash_screen.dart';
import '../../presentation/screens/welcome_screen.dart';
import '../../presentation/screens/login_screen.dart';
import '../../presentation/screens/otp_screen.dart';
import '../../presentation/screens/register_screen.dart';
import '../../presentation/screens/complete_profile_screen.dart';
import '../../presentation/screens/home_screen.dart';
import '../../presentation/screens/product_listing_screen.dart';
import '../../presentation/screens/product_details_screen.dart';
import '../../presentation/screens/cart_screen.dart';
import '../../presentation/screens/checkout_screen.dart';
import '../../presentation/screens/order_success_screen.dart';
import '../../presentation/screens/live_tracking_screen.dart';
import '../../presentation/screens/order_history_screen.dart';
import '../../presentation/screens/favorites_screen.dart';
import '../../presentation/screens/notifications_screen.dart';
import '../../presentation/screens/edit_profile_screen.dart';
import '../../presentation/screens/address_screen.dart';
import '../../presentation/screens/settings_screen.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String otp = '/otp';
  static const String register = '/register';
  static const String completeProfile = '/complete-profile';
  static const String home = '/';
  static const String productListing = '/product-listing';
  static const String productDetails = '/product-details';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String liveTracking = '/live-tracking';
  static const String success = '/success';
  static const String editProfile = '/edit-profile';
  static const String address = '/address';
  static const String settings = '/settings';
  static const String orderHistory = '/order-history';
  static const String favorites = '/favorites';
  static const String notifications = '/notifications';
  static const String adminDashboard = '/admin/dashboard';
  static const String adminMenu = '/admin/menu';
}

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    redirect: (context, state) {
      final loc = state.uri.path;
      final isAuth = authState.isAuthenticated;

      // Public authentication routes
      final publicRoutes = [
        AppRoutes.splash,
        AppRoutes.welcome,
        AppRoutes.login,
        AppRoutes.otp,
        AppRoutes.register,
      ];

      if (!isAuth) {
        if (!publicRoutes.contains(loc)) {
          return AppRoutes.login;
        }
      } else {
        // If authenticated, do not allow returning to login/register/otp
        if (loc == AppRoutes.login ||
            loc == AppRoutes.otp ||
            loc == AppRoutes.register ||
            loc == AppRoutes.welcome) {
          return AppRoutes.home;
        }
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.otp,
        builder: (context, state) => const OtpScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.completeProfile,
        builder: (context, state) => const CompleteProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.productListing,
        builder: (context, state) => const ProductListingScreen(),
      ),
      GoRoute(
        path: AppRoutes.productDetails,
        builder: (context, state) {
          final prod = state.extra as ProductEntity;
          return ProductDetailsScreen(product: prod);
        },
      ),
      GoRoute(
        path: AppRoutes.cart,
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: AppRoutes.checkout,
        builder: (context, state) => const CheckoutScreen(),
      ),
      GoRoute(
        path: AppRoutes.liveTracking,
        builder: (context, state) => const LiveOrderTrackingScreen(),
      ),
      GoRoute(
        path: AppRoutes.success,
        builder: (context, state) => const OrderSuccessScreen(),
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.address,
        builder: (context, state) => const AddressScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.orderHistory,
        builder: (context, state) => const OrderHistoryScreen(),
      ),
      GoRoute(
        path: AppRoutes.favorites,
        builder: (context, state) => const FavoritesScreen(),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: AppRoutes.adminDashboard,
        builder: (context, state) => const PlaceholderScreen(title: 'Admin Dashboard'),
      ),
      GoRoute(
        path: AppRoutes.adminMenu,
        builder: (context, state) => const PlaceholderScreen(title: 'Admin Menu Management'),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.error}'),
      ),
    ),
  );
});
