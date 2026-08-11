enum AdminRole { owner, manager, staff }

class AdminEntity {
  final String uid;
  final String name;
  final String email;
  final AdminRole role;
  final bool isActive;

  const AdminEntity({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    this.isActive = true,
  });
}
