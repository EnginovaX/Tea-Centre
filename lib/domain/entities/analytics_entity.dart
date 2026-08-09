class AnalyticsEntity {
  final double totalRevenueToday;
  final int totalOrdersToday;
  final int pendingOrdersCount;
  final int activeCustomersCount;
  final List<double> weeklyRevenue;
  final List<double> monthlyRevenue;

  const AnalyticsEntity({
    required this.totalRevenueToday,
    required this.totalOrdersToday,
    required this.pendingOrdersCount,
    required this.activeCustomersCount,
    required this.weeklyRevenue,
    required this.monthlyRevenue,
  });
}
