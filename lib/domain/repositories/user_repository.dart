import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<UserEntity?> getUserById(String uid);

  Future<void> createUser(UserEntity user);

  Future<void> updateUser(UserEntity user);
}
