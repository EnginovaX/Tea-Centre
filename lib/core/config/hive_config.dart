import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Configuration class for Hive Local Databases.
/// Pre-registers database adapters, settings, and boxes.
class HiveConfig {
  static const String favoritesBoxName = 'favorites_box';
  static const String settingsBoxName = 'settings_box';

  static Future<void> initialize() async {
    await Hive.initFlutter();

    // Register Box Adapters here
    // e.g. Hive.registerAdapter(UserAdapter());

    // Open common boxes
    await Hive.openBox<dynamic>(favoritesBoxName);
    await Hive.openBox<dynamic>(settingsBoxName);

    if (kDebugMode) {
      print('Hive Local Database Storage initialized with boxes: [$favoritesBoxName, $settingsBoxName]');
    }
  }
}
