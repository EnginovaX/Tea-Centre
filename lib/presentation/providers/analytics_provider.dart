import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/analytics_entity.dart';
import '../../data/repositories/analytics_repository_impl.dart';

class AnalyticsNotifier extends StateNotifier<AsyncValue<AnalyticsEntity>> {
  final _repository = AnalyticsRepositoryImpl();

  AnalyticsNotifier() : super(const AsyncValue.loading()) {
    loadMetrics();
  }

  Future<void> loadMetrics() async {
    try {
      final metrics = await _repository.getMetrics();
      state = AsyncValue.data(metrics);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final analyticsProvider = StateNotifierProvider<AnalyticsNotifier, AsyncValue<AnalyticsEntity>>((ref) {
  return AnalyticsNotifier();
});
