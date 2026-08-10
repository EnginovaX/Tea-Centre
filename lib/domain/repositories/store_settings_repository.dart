import '../entities/store_settings_entity.dart';

abstract class StoreSettingsRepository {
  Future<StoreSettingsEntity> getSettings();
  Future<void> updateSettings(StoreSettingsEntity settings);
  Future<bool> checkStoreOpenStatus();
}
