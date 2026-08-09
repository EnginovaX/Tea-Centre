import '../entities/notification_entity.dart';

abstract class NotificationRepository {
  Future<List<NotificationEntity>> getNotifications();
  Future<void> sendNotification(NotificationEntity notification);
  Future<void> markAsRead(String notificationId);
}
