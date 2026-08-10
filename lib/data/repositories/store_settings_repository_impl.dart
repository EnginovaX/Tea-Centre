import '../../domain/entities/store_settings_entity.dart';
import '../../domain/repositories/store_settings_repository.dart';
import '../datasources/firestore_service.dart';

class StoreSettingsRepositoryImpl implements StoreSettingsRepository {
  // Local in-memory singleton cache/fallback to satisfy standard operational settings
  static StoreSettingsEntity _currentSettings = const StoreSettingsEntity(
    isStoreOpen: true,
    openingTime: "09:00 AM",
    closingTime: "10:00 PM",
    deliveryRadiusKm: 10.0,
    minOrderAmount: 100.0,
    deliveryCharge: 30.0,
    taxRate: 5.0, // 5% GST
  );

  StoreSettingsRepositoryImpl({required FirestoreService firestoreService});

  @override
  Future<StoreSettingsEntity> getSettings() async {
    // Simulates an async remote database retrieval
    await Future.delayed(const Duration(milliseconds: 100));
    return _currentSettings;
  }

  @override
  Future<void> updateSettings(StoreSettingsEntity settings) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _currentSettings = settings;
  }

  @override
  Future<bool> checkStoreOpenStatus() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _currentSettings.isStoreOpen;
  }
}
