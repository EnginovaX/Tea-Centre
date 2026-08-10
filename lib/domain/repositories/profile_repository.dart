import 'dart:io';
import '../entities/user_entity.dart';

abstract class ProfileRepository {
  Future<UserEntity> getProfile(String uid);

  Future<void> updateProfile({
    required String uid,
    required String fullName,
    required String email,
  });

  Future<String> uploadProfilePhoto(String uid, File imageFile);
}
