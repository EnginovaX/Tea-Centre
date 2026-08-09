import '../../domain/entities/coupon_entity.dart';
import '../../domain/repositories/coupon_repository.dart';

class CouponRepositoryImpl implements CouponRepository {
  final List<CouponEntity> _mockCoupons = [
    CouponEntity(
      code: 'CHAI10',
      description: 'Get 10% off on all chais',
      type: CouponType.percentage,
      value: 10.0,
      minOrderAmount: 150.0,
      expiryDate: DateTime.now().add(const Duration(days: 30)),
      isActive: true,
    ),
    CouponEntity(
      code: 'MONSOON20',
      description: 'Get 20% off on Monsoon Specials',
      type: CouponType.percentage,
      value: 20.0,
      minOrderAmount: 250.0,
      expiryDate: DateTime.now().add(const Duration(days: 30)),
      isActive: true,
    ),
  ];

  @override
  Future<List<CouponEntity>> getCoupons() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _mockCoupons;
  }

  @override
  Future<void> addCoupon(CouponEntity coupon) async {
    await Future.delayed(const Duration(milliseconds: 50));
    _mockCoupons.add(coupon);
  }

  @override
  Future<void> toggleCouponStatus(String code, bool isActive) async {
    await Future.delayed(const Duration(milliseconds: 50));
    final index = _mockCoupons.indexWhere((c) => c.code == code);
    if (index != -1) {
      final c = _mockCoupons[index];
      _mockCoupons[index] = CouponEntity(
        code: c.code,
        description: c.description,
        type: c.type,
        value: c.value,
        minOrderAmount: c.minOrderAmount,
        expiryDate: c.expiryDate,
        isActive: isActive,
      );
    }
  }
}
