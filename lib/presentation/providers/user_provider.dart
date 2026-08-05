import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_entity.dart';
import 'dependency_providers.dart';

class UserNotifier extends StateNotifier<UserEntity?> {
  final Ref _ref;

  UserNotifier(this._ref) : super(null);

  Future<void> fetchUser(String uid) async {
    final user = await _ref.read(userRepositoryProvider).getUserById(uid);
    if (user != null) {
      state = user;
    }
  }

  Future<void> registerUser(UserEntity user) async {
    await _ref.read(userRepositoryProvider).createUser(user);
    state = user;
  }

  Future<void> updateUser(UserEntity user) async {
    await _ref.read(userRepositoryProvider).updateUser(user);
    state = user;
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserEntity?>((ref) {
  return UserNotifier(ref);
});
