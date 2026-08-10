class OfferEntity {
  final String code;
  final String description;
  final double discountPercent;
  final double maxDiscountAmount;

  const OfferEntity({
    required this.code,
    required this.description,
    required this.discountPercent,
    required this.maxDiscountAmount,
  });
}
