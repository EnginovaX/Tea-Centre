import '../../domain/entities/analytics_entity.dart';
import '../../domain/repositories/analytics_repository.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  @override
  Future<AnalyticsEntity> getMetrics() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return const AnalyticsEntity(
      totalRevenueToday: 18450.0,
      totalOrdersToday: 24,
      pendingOrdersCount: 5,
      activeCustomersCount: 1248,
      weeklyRevenue: [12000, 15000, 18450, 14000, 16000, 17500, 19000],
      monthlyRevenue: [420000, 450000, 480000, 520000],
    );
  }
}
