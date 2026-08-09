import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final List<NotificationEntity> _mockNotifications = [];

  @override
  Future<List<NotificationEntity>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _mockNotifications;
  }

  @override
  Future<void> sendNotification(NotificationEntity notification) async {
    await Future.delayed(const Duration(milliseconds: 50));
    _mockNotifications.insert(0, notification);
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    await Future.delayed(const Duration(milliseconds: 50));
    final index = _mockNotifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _mockNotifications[index] = _mockNotifications[index].copyWith(isRead: true);
    }
  }
}
