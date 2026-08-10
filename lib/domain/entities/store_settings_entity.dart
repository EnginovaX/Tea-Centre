class StoreSettingsEntity {
  final bool isStoreOpen;
  final String openingTime;
  final String closingTime;
  final double deliveryRadiusKm;
  final double minOrderAmount;
  final double deliveryCharge;
  final double taxRate; // e.g., 5.0 for 5% GST

  const StoreSettingsEntity({
    required this.isStoreOpen,
    required this.openingTime,
    required this.closingTime,
    required this.deliveryRadiusKm,
    required this.minOrderAmount,
    required this.deliveryCharge,
    required this.taxRate,
  });

  StoreSettingsEntity copyWith({
    bool? isStoreOpen,
    String? openingTime,
    String? closingTime,
    double? deliveryRadiusKm,
    double? minOrderAmount,
    double? deliveryCharge,
    double? taxRate,
  }) {
    return StoreSettingsEntity(
      isStoreOpen: isStoreOpen ?? this.isStoreOpen,
      openingTime: openingTime ?? this.openingTime,
      closingTime: closingTime ?? this.closingTime,
      deliveryRadiusKm: deliveryRadiusKm ?? this.deliveryRadiusKm,
      minOrderAmount: minOrderAmount ?? this.minOrderAmount,
      deliveryCharge: deliveryCharge ?? this.deliveryCharge,
      taxRate: taxRate ?? this.taxRate,
    );
  }
}
