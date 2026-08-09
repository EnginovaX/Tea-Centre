import '../../domain/entities/inventory_entity.dart';
import '../../domain/repositories/inventory_repository.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  final List<InventoryEntity> _mockInventory = [
    InventoryEntity(
      productId: 'p1',
      productName: 'Assam CTC Tea Leaves',
      stockCount: 4,
      lowStockThreshold: 5,
      isAvailable: true,
      lastUpdated: DateTime.now(),
    ),
    InventoryEntity(
      productId: 'p2',
      productName: 'Premium Cardamom Pods',
      stockCount: 15,
      lowStockThreshold: 5,
      isAvailable: true,
      lastUpdated: DateTime.now(),
    ),
    InventoryEntity(
      productId: 'p3',
      productName: 'Fresh Full-Cream Milk',
      stockCount: 3,
      lowStockThreshold: 8,
      isAvailable: true,
      lastUpdated: DateTime.now(),
    ),
  ];

  @override
  Future<List<InventoryEntity>> getInventory() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _mockInventory;
  }

  @override
  Future<void> updateStock(String productId, int quantity) async {
    await Future.delayed(const Duration(milliseconds: 50));
    final index = _mockInventory.indexWhere((item) => item.productId == productId);
    if (index != -1) {
      final item = _mockInventory[index];
      final newCount = item.stockCount + quantity;
      _mockInventory[index] = item.copyWith(
        stockCount: newCount,
        lastUpdated: DateTime.now(),
      );
    }
  }

  @override
  Future<void> triggerLowStockAlert(String productId, int threshold) async {
    await Future.delayed(const Duration(milliseconds: 50));
  }
}
