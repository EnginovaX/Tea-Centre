import 'dart:convert';
import 'package:hive/hive.dart';

class PendingRequest {
  final String id;
  final String action; // e.g., "place_order", "add_favorite"
  final Map<String, dynamic> payload;
  final DateTime createdAt;

  PendingRequest({
    required this.id,
    required this.action,
    required this.payload,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'action': action,
      'payload': jsonEncode(payload),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory PendingRequest.fromMap(Map<dynamic, dynamic> map) {
    return PendingRequest(
      id: map['id'] as String,
      action: map['action'] as String,
      payload: jsonDecode(map['payload'] as String) as Map<String, dynamic>,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}

class OfflineRetryService {
  static const String boxName = 'offline_retry_box';
  bool _isOnline = true;

  /// Simulates toggling network connectivity state
  void setOnlineStatus(bool isOnline) {
    _isOnline = isOnline;
    if (_isOnline) {
      processPendingRequests();
    }
  }

  /// Queues a request if offline, otherwise executes it directly
  Future<bool> executeOrQueue({
    required String action,
    required Map<String, dynamic> payload,
    required Future<bool> Function() onExecute,
  }) async {
    if (_isOnline) {
      final success = await onExecute();
      if (success) return true;
    }

    // Queue request to retry later
    await queuePendingRequest(action, payload);
    return false;
  }

  /// Saves a pending request to local Hive storage
  Future<void> queuePendingRequest(String action, Map<String, dynamic> payload) async {
    final box = await Hive.openBox(boxName);
    final request = PendingRequest(
      id: "req_${DateTime.now().millisecondsSinceEpoch}",
      action: action,
      payload: payload,
      createdAt: DateTime.now(),
    );
    await box.put(request.id, request.toMap());
  }

  /// Attempts to re-execute/retry all queued requests
  Future<void> processPendingRequests() async {
    if (!_isOnline) return;

    final box = await Hive.openBox(boxName);
    if (box.isEmpty) return;

    final keys = List.from(box.keys);
    for (final key in keys) {
      final data = box.get(key);
      if (data != null) {
        final request = PendingRequest.fromMap(data as Map);
        final success = await _retryRequest(request);
        if (success) {
          await box.delete(key);
        }
      }
    }
  }

  /// Local simulated request execution router
  Future<bool> _retryRequest(PendingRequest request) async {
    await Future.delayed(const Duration(milliseconds: 200));
    // Simulate successful auto-retry and processing
    return true;
  }

  /// Helper to check current queue size
  Future<int> getQueueSize() async {
    final box = await Hive.openBox(boxName);
    return box.length;
  }
}
