import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/order_entity.dart';
import 'dependency_providers.dart';

class OrderNotifier extends StateNotifier<AsyncValue<List<OrderEntity>>> {
  final Ref _ref;

  OrderNotifier(this._ref) : super(const AsyncValue.loading());

  Future<void> fetchOrders(String userId) async {
    state = const AsyncValue.loading();
    try {
      final list = await _ref.read(orderRepositoryProvider).getOrders(userId);
      state = AsyncValue.data(list);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> placeOrder(OrderEntity order) async {
    try {
      await _ref.read(orderRepositoryProvider).placeOrder(order);
      await fetchOrders(order.userId);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Stream<OrderEntity> trackOrder(String orderId) {
    return _ref.read(orderRepositoryProvider).streamOrderTracking(orderId);
  }
}

final orderProvider = StateNotifierProvider<OrderNotifier, AsyncValue<List<OrderEntity>>>((ref) {
  return OrderNotifier(ref);
});
