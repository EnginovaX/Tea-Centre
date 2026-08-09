import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/coupon_entity.dart';
import '../../data/repositories/coupon_repository_impl.dart';

class CouponNotifier extends StateNotifier<AsyncValue<List<CouponEntity>>> {
  final _repository = CouponRepositoryImpl();

  CouponNotifier() : super(const AsyncValue.loading()) {
    loadCoupons();
  }

  Future<void> loadCoupons() async {
    try {
      final list = await _repository.getCoupons();
      state = AsyncValue.data(list);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> createAndPublishCoupon(CouponEntity coupon) async {
    try {
      await _repository.addCoupon(coupon);
      await loadCoupons();
    } catch (_) {}
  }

  Future<void> toggleStatus(String code, bool isActive) async {
    try {
      await _repository.toggleCouponStatus(code, isActive);
      await loadCoupons();
    } catch (_) {}
  }
}

final couponProvider = StateNotifierProvider<CouponNotifier, AsyncValue<List<CouponEntity>>>((ref) {
  return CouponNotifier();
});
