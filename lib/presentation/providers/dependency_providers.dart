import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/firebase_auth_service.dart';
import '../../data/datasources/firestore_service.dart';
import '../../data/datasources/session_manager.dart';
import '../../data/datasources/storage_service.dart';
import '../../data/repositories/address_repository_impl.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/repositories/address_repository.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/repositories/user_repository.dart';

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
