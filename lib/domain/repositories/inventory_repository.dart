import '../entities/inventory_entity.dart';

abstract class InventoryRepository {
  Future<List<InventoryEntity>> getInventory();
  Future<void> updateStock(String productId, int quantity);
  Future<void> triggerLowStockAlert(String productId, int threshold);
}
