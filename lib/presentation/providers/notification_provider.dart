import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/notification_entity.dart';
import '../../data/repositories/notification_repository_impl.dart';

class NotificationNotifier extends StateNotifier<AsyncValue<List<NotificationEntity>>> {
  final _repository = NotificationRepositoryImpl();

  NotificationNotifier() : super(const AsyncValue.loading()) {
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    try {
      final list = await _repository.getNotifications();
      state = AsyncValue.data(list);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> sendPush(NotificationEntity n) async {
    try {
      await _repository.sendNotification(n);
      await loadNotifications();
    } catch (_) {}
  }

  Future<void> markRead(String id) async {
    try {
      await _repository.markAsRead(id);
      await loadNotifications();
    } catch (_) {}
  }
}

final notificationProvider = StateNotifierProvider<NotificationNotifier, AsyncValue<List<NotificationEntity>>>((ref) {
  return NotificationNotifier();
});
