import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/firebase_auth_service.dart';
import '../../data/datasources/firestore_service.dart';
import '../../data/datasources/session_manager.dart';
import '../../data/datasources/storage_service.dart';
import '../../data/datasources/maps_service.dart';

// Import newly created and pre-existing repositories
import '../../data/repositories/address_repository_impl.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../data/repositories/menu_repository_impl.dart';
import '../../data/repositories/cart_repository_impl.dart';
import '../../data/repositories/order_repository_impl.dart';
import '../../data/repositories/favorite_repository_impl.dart';
import '../../data/repositories/analytics_repository_impl.dart';
import '../../data/repositories/inventory_repository_impl.dart';
import '../../data/repositories/coupon_repository_impl.dart';
import '../../data/repositories/customer_repository_impl.dart';
import '../../data/repositories/notification_repository_impl.dart';
import '../../data/repositories/delivery_repository_impl.dart';

import '../../domain/repositories/address_repository.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/repositories/menu_repository.dart';
import '../../domain/repositories/cart_repository.dart';
import '../../domain/repositories/order_repository.dart';
import '../../domain/repositories/favorite_repository.dart';
import '../../domain/repositories/analytics_repository.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../../domain/repositories/coupon_repository.dart';
import '../../domain/repositories/customer_repository.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../domain/repositories/delivery_repository.dart';

// Services
final firebaseAuthServiceProvider = Provider<FirebaseAuthService>((ref) {
  return FirebaseAuthService();
});

final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

final sessionManagerProvider = Provider<SessionManager>((ref) {
  return SessionManager();
});

final mapsServiceProvider = Provider<MapsService>((ref) {
  return MapsService();
});

// Repositories
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    authService: ref.watch(firebaseAuthServiceProvider),
    sessionManager: ref.watch(sessionManagerProvider),
  );
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepositoryImpl(
    firestoreService: ref.watch(firestoreServiceProvider),
    sessionManager: ref.watch(sessionManagerProvider),
  );
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl(
    firestoreService: ref.watch(firestoreServiceProvider),
    storageService: ref.watch(storageServiceProvider),
    sessionManager: ref.watch(sessionManagerProvider),
  );
});

final addressRepositoryProvider = Provider<AddressRepository>((ref) {
  return AddressRepositoryImpl(
    firestoreService: ref.watch(firestoreServiceProvider),
    sessionManager: ref.watch(sessionManagerProvider),
  );
});

final menuRepositoryProvider = Provider<MenuRepository>((ref) {
  return MenuRepositoryImpl(
    firestoreService: ref.watch(firestoreServiceProvider),
    sessionManager: ref.watch(sessionManagerProvider),
  );
});

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  return CartRepositoryImpl(
    firestoreService: ref.watch(firestoreServiceProvider),
    sessionManager: ref.watch(sessionManagerProvider),
  );
});

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepositoryImpl(
    firestoreService: ref.watch(firestoreServiceProvider),
  );
});

final favoriteRepositoryProvider = Provider<FavoriteRepository>((ref) {
  return FavoriteRepositoryImpl(
    firestoreService: ref.watch(firestoreServiceProvider),
    sessionManager: ref.watch(sessionManagerProvider),
  );
});

final analyticsRepositoryProvider = Provider<AnalyticsRepository>((ref) {
  return AnalyticsRepositoryImpl();
});

final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) {
  return InventoryRepositoryImpl();
});

final couponRepositoryProvider = Provider<CouponRepository>((ref) {
  return CouponRepositoryImpl();
});

final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  return CustomerRepositoryImpl();
});

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepositoryImpl();
});

final deliveryRepositoryProvider = Provider<DeliveryRepository>((ref) {
  return DeliveryRepositoryImpl(
    mapsService: ref.watch(mapsServiceProvider),
  );
});
