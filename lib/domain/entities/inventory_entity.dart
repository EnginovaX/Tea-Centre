class InventoryEntity {
  final String productId;
  final String productName;
  final int stockCount;
  final int lowStockThreshold;
  final bool isAvailable;
  final DateTime lastUpdated;

  const InventoryEntity({
    required this.productId,
    required this.productName,
    required this.stockCount,
    this.lowStockThreshold = 10,
    required this.isAvailable,
    required this.lastUpdated,
  });

  bool get isLowStock => stockCount <= lowStockThreshold;

  InventoryEntity copyWith({
    String? productId,
    String? productName,
    int? stockCount,
    int? lowStockThreshold,
    bool? isAvailable,
    DateTime? lastUpdated,
  }) {
    return InventoryEntity(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      stockCount: stockCount ?? this.stockCount,
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
      isAvailable: isAvailable ?? this.isAvailable,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
