import 'dart:async';
import '../../domain/entities/notification_entity.dart';

class NotificationService {
  final _messageController = StreamController<NotificationEntity>.broadcast();

  /// Stream of real-time FCM notification messages
  Stream<NotificationEntity> get onMessageStream => _messageController.stream;

  /// Retrieves the Firebase Cloud Messaging (FCM) device push token
  Future<String> getDeviceToken() async {
    // Simulates retrieval of real FCM device registration token
    await Future.delayed(const Duration(milliseconds: 300));
    return "fcm_token_tea_centre_client_device_${DateTime.now().microsecondsSinceEpoch}";
  }

  /// Registers/Subscribes the device to an FCM Topic (e.g., "all_users" or "offers")
  Future<void> subscribeToTopic(String topic) async {
    await Future.delayed(const Duration(milliseconds: 100));
    // Simulated subscribe call
  }

  /// Disposes of the real-time Stream Controller
  void dispose() {
    _messageController.close();
  }

  /// Triggers a mock FCM push notification stream event
  /// Useful for testing, simulating store-sent push updates in foreground/background.
  void simulateIncomingPushNotification({
    required String title,
    required String body,
    required String type,
  }) {
    final pushNotification = NotificationEntity(
      id: "push_${DateTime.now().millisecondsSinceEpoch}",
      title: title,
      body: body,
      type: type,
      timestamp: DateTime.now(),
      isRead: false,
    );
    _messageController.add(pushNotification);
  }
}
