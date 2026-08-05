import 'package:hive_flutter/hive_flutter.dart';

class SessionManager {
  final Box _settingsBox;

  SessionManager({Box? settingsBox})
      : _settingsBox = settingsBox ?? Hive.box('settings_box');

  static const String _userProfileKey = 'user_profile';
  static const String _addressesKey = 'addresses';
  static const String _sessionKey = 'session_auth';

  // Session Caching
  Future<void> cacheSession(Map<String, dynamic> sessionData) async {
    await _settingsBox.put(_sessionKey, sessionData);
  }

  Map<String, dynamic>? getCachedSession() {
    final data = _settingsBox.get(_sessionKey);
    if (data == null) return null;
    return Map<String, dynamic>.from(data);
  }

  Future<void> clearSession() async {
    await _settingsBox.delete(_sessionKey);
    await _settingsBox.delete(_userProfileKey);
    await _settingsBox.delete(_addressesKey);
  }

  // User Profile Caching
  Future<void> cacheUserProfile(Map<String, dynamic> profileData) async {
    await _settingsBox.put(_userProfileKey, profileData);
  }

  Map<String, dynamic>? getCachedUserProfile() {
    final data = _settingsBox.get(_userProfileKey);
    if (data == null) return null;
    return Map<String, dynamic>.from(data);
  }

  // Address Caching
  Future<void> cacheAddresses(List<Map<String, dynamic>> addresses) async {
    await _settingsBox.put(_addressesKey, addresses);
  }

  List<Map<String, dynamic>>? getCachedAddresses() {
    final list = _settingsBox.get(_addressesKey);
    if (list == null) return null;
    return (list as List).map((item) => Map<String, dynamic>.from(item)).toList();
  }
}
