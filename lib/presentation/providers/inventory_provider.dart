import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/inventory_entity.dart';
import '../../data/repositories/inventory_repository_impl.dart';

class InventoryNotifier extends StateNotifier<AsyncValue<List<InventoryEntity>>> {
  final _repository = InventoryRepositoryImpl();

  InventoryNotifier() : super(const AsyncValue.loading()) {
    loadInventory();
  }

  Future<void> loadInventory() async {
    try {
      final list = await _repository.getInventory();
      state = AsyncValue.data(list);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> restockItem(String productId, int qty) async {
    try {
      await _repository.updateStock(productId, qty);
      await loadInventory();
    } catch (_) {}
  }
}

final inventoryProvider = StateNotifierProvider<InventoryNotifier, AsyncValue<List<InventoryEntity>>>((ref) {
  return InventoryNotifier();
});
