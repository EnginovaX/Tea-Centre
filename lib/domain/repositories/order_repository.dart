import '../entities/order_entity.dart';
import '../entities/notification_entity.dart';

abstract class OrderRepository {
  Future<void> placeOrder(OrderEntity order);

  Future<List<OrderEntity>> getOrders(String userId);

  Future<OrderEntity?> getOrderById(String orderId);

  Stream<OrderEntity> streamOrderTracking(String orderId);

  Future<List<NotificationEntity>> getNotifications(String userId);
}
