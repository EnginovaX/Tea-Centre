import 'address_entity.dart';

class UserEntity {
  final String uid;
  final String fullName;
  final String phoneNumber;
  final String email;
  final String? profilePhotoUrl;
  final List<AddressEntity> savedAddresses;
  final DateTime createdAt;

  const UserEntity({
    required this.uid,
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    this.profilePhotoUrl,
    this.savedAddresses = const [],
    required this.createdAt,
  });

  UserEntity copyWith({
    String? uid,
    String? fullName,
    String? phoneNumber,
    String? email,
    String? profilePhotoUrl,
    List<AddressEntity>? savedAddresses,
    DateTime? createdAt,
  }) {
    return UserEntity(
      uid: uid ?? this.uid,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      savedAddresses: savedAddresses ?? this.savedAddresses,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
