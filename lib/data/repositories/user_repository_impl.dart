import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/firestore_service.dart';
import '../datasources/session_manager.dart';

class UserRepositoryImpl implements UserRepository {
  final FirestoreService _firestoreService;
  final SessionManager _sessionManager;

  UserRepositoryImpl({
    required FirestoreService firestoreService,
    required SessionManager sessionManager,
  })  : _firestoreService = firestoreService,
        _sessionManager = sessionManager;

  @override
  Future<UserEntity?> getUserById(String uid) async {
    // Offline caching first fallback
    final cachedProfile = _sessionManager.getCachedUserProfile();
    if (cachedProfile != null && cachedProfile['uid'] == uid) {
      return _mapToEntity(cachedProfile);
    }

    try {
      final data = await _firestoreService.getUser(uid);
      if (data != null) {
        await _sessionManager.cacheUserProfile(data);
        return _mapToEntity(data);
      }
    } catch (_) {
      // Return cached fallback on exception
      if (cachedProfile != null) {
        return _mapToEntity(cachedProfile);
      }
    }
    return null;
  }

  @override
  Future<void> createUser(UserEntity user) async {
    final rawData = _mapToMap(user);
    await _firestoreService.saveUser(user.uid, rawData);
    await _sessionManager.cacheUserProfile(rawData);
  }

  @override
  Future<void> updateUser(UserEntity user) async {
    final rawData = _mapToMap(user);
    await _firestoreService.saveUser(user.uid, rawData);
    await _sessionManager.cacheUserProfile(rawData);
  }

  UserEntity _mapToEntity(Map<String, dynamic> data) {
    return UserEntity(
      uid: data['uid'] as String,
      fullName: data['fullName'] as String? ?? '',
      phoneNumber: data['phoneNumber'] as String? ?? '',
      email: data['email'] as String? ?? '',
      profilePhotoUrl: data['profilePhotoUrl'] as String?,
      createdAt: data['createdAt'] != null
          ? DateTime.parse(data['createdAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> _mapToMap(UserEntity user) {
    return {
      'uid': user.uid,
      'fullName': user.fullName,
      'phoneNumber': user.phoneNumber,
      'email': user.email,
      'profilePhotoUrl': user.profilePhotoUrl,
      'createdAt': user.createdAt.toIso8601String(),
    };
  }
}
