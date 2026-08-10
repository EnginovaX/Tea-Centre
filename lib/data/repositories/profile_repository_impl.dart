import 'dart:io';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/firestore_service.dart';
import '../datasources/session_manager.dart';
import '../datasources/storage_service.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final FirestoreService _firestoreService;
  final StorageService _storageService;
  final SessionManager _sessionManager;

  ProfileRepositoryImpl({
    required FirestoreService firestoreService,
    required StorageService storageService,
    required SessionManager sessionManager,
  })  : _firestoreService = firestoreService,
        _storageService = storageService,
        _sessionManager = sessionManager;

  @override
  Future<UserEntity> getProfile(String uid) async {
    final cached = _sessionManager.getCachedUserProfile();
    if (cached != null) {
      return _mapToEntity(cached);
    }

    final data = await _firestoreService.getUser(uid);
    if (data == null) throw Exception('Profile not found');
    await _sessionManager.cacheUserProfile(data);
    return _mapToEntity(data);
  }

  @override
  Future<void> updateProfile({
    required String uid,
    required String fullName,
    required String email,
  }) async {
    final cached = _sessionManager.getCachedUserProfile() ?? {};
    cached['uid'] = uid;
    cached['fullName'] = fullName;
    cached['email'] = email;

    await _firestoreService.saveUser(uid, cached);
    await _sessionManager.cacheUserProfile(cached);
  }

  @override
  Future<String> uploadProfilePhoto(String uid, File imageFile) async {
    final url = await _storageService.uploadProfilePhoto(uid, imageFile);
    final cached = _sessionManager.getCachedUserProfile() ?? {};
    cached['profilePhotoUrl'] = url;

    await _firestoreService.saveUser(uid, {'profilePhotoUrl': url});
    await _sessionManager.cacheUserProfile(cached);
    return url;
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
}
