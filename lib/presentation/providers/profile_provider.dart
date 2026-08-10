import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_entity.dart';
import 'dependency_providers.dart';
import 'user_provider.dart';

class ProfileNotifier extends StateNotifier<AsyncValue<UserEntity>> {
  final Ref _ref;

  ProfileNotifier(this._ref) : super(const AsyncValue.loading());

  Future<void> loadProfile(String uid) async {
    state = const AsyncValue.loading();
    try {
      final profile = await _ref.read(profileRepositoryProvider).getProfile(uid);
      state = AsyncValue.data(profile);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateProfile({
    required String uid,
    required String fullName,
    required String email,
  }) async {
    try {
      await _ref.read(profileRepositoryProvider).updateProfile(
            uid: uid,
            fullName: fullName,
            email: email,
          );
      final updated = await _ref.read(profileRepositoryProvider).getProfile(uid);
      state = AsyncValue.data(updated);
      _ref.read(userProvider.notifier).fetchUser(uid);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateProfilePhoto(String uid, File file) async {
    try {
      await _ref.read(profileRepositoryProvider).uploadProfilePhoto(uid, file);
      final updated = await _ref.read(profileRepositoryProvider).getProfile(uid);
      state = AsyncValue.data(updated);
      _ref.read(userProvider.notifier).fetchUser(uid);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final profileProvider = StateNotifierProvider<ProfileNotifier, AsyncValue<UserEntity>>((ref) {
  return ProfileNotifier(ref);
});
