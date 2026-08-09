import '../../domain/entities/customer_entity.dart';
import '../../domain/repositories/customer_repository.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  final List<CustomerEntity> _mockCustomers = [
    const CustomerEntity(
      id: 'c101',
      name: 'Amit Sharma',
      email: 'amit@gmail.com',
      phone: '+91 98765 43210',
      totalOrders: 18,
      lifetimeSpend: 3450.0,
      lastActive: 'Today',
    ),
    const CustomerEntity(
      id: 'c102',
      name: 'Priya Patel',
      email: 'priya@gmail.com',
      phone: '+91 91234 56789',
      totalOrders: 12,
      lifetimeSpend: 2180.0,
      lastActive: 'Yesterday',
    ),
  ];

  @override
  Future<List<CustomerEntity>> getCustomers() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _mockCustomers;
  }
}
