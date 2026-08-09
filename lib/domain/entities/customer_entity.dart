class CustomerEntity {
  final String id;
  final String name;
  final String email;
  final String phone;
  final int totalOrders;
  final double lifetimeSpend;
  final String lastActive;

  const CustomerEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.totalOrders,
    required this.lifetimeSpend,
    required this.lastActive,
  });
}
