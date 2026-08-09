import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/customer_entity.dart';
import '../../data/repositories/customer_repository_impl.dart';

class CustomerNotifier extends StateNotifier<AsyncValue<List<CustomerEntity>>> {
  final _repository = CustomerRepositoryImpl();

  CustomerNotifier() : super(const AsyncValue.loading()) {
    loadCustomers();
  }

  Future<void> loadCustomers() async {
    try {
      final list = await _repository.getCustomers();
      state = AsyncValue.data(list);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final customerProvider = StateNotifierProvider<CustomerNotifier, AsyncValue<List<CustomerEntity>>>((ref) {
  return CustomerNotifier();
});
