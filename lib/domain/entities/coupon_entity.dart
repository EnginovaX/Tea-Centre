enum CouponType { percentage, flat, buyOneGetOne }

class CouponEntity {
  final String code;
  final String description;
  final CouponType type;
  final double value; // Percent value or Flat amount
  final double minOrderAmount;
  final DateTime expiryDate;
  final bool isActive;

  const CouponEntity({
    required this.code,
    required this.description,
    required this.type,
    required this.value,
    this.minOrderAmount = 0.0,
    required this.expiryDate,
    this.isActive = true,
  });
}
