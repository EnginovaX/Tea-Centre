import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/store_settings_entity.dart';
import '../../domain/repositories/store_settings_repository.dart';
import '../../data/repositories/store_settings_repository_impl.dart';
import 'dependency_providers.dart';

// Declare a provider for the Repository implementation
final storeSettingsRepositoryProvider = Provider<StoreSettingsRepository>((ref) {
  return StoreSettingsRepositoryImpl(
    firestoreService: ref.watch(firestoreServiceProvider),
  );
});

class StoreSettingsNotifier extends StateNotifier<StoreSettingsEntity> {
  final StoreSettingsRepository _repository;

  StoreSettingsNotifier(this._repository)
      : super(const StoreSettingsEntity(
          isStoreOpen: true,
          openingTime: "09:00 AM",
          closingTime: "10:00 PM",
          deliveryRadiusKm: 10.0,
          minOrderAmount: 100.0,
          deliveryCharge: 30.0,
          taxRate: 5.0,
        )) {
    loadSettings();
  }

  Future<void> loadSettings() async {
    try {
      final settings = await _repository.getSettings();
      state = settings;
    } catch (_) {
      // Keep defaults on failure
    }
  }

  Future<void> updateSettings(StoreSettingsEntity newSettings) async {
    try {
      await _repository.updateSettings(newSettings);
      state = newSettings;
    } catch (_) {
      // Handle error accordingly
    }
  }

  Future<void> toggleStoreOpenStatus(bool isOpen) async {
    final updated = state.copyWith(isStoreOpen: isOpen);
    await updateSettings(updated);
  }
}

final storeSettingsProvider = StateNotifierProvider<StoreSettingsNotifier, StoreSettingsEntity>((ref) {
  final repository = ref.watch(storeSettingsRepositoryProvider);
  return StoreSettingsNotifier(repository);
});
