import '../entities/coupon_entity.dart';

abstract class CouponRepository {
  Future<List<CouponEntity>> getCoupons();
  Future<void> addCoupon(CouponEntity coupon);
  Future<void> toggleCouponStatus(String code, bool isActive);
}
