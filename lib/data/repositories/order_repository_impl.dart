import '../../domain/entities/order_entity.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/firestore_service.dart';

class OrderRepositoryImpl implements OrderRepository {
  final FirestoreService _firestoreService;

  OrderRepositoryImpl({
    required FirestoreService firestoreService,
  }) : _firestoreService = firestoreService;

  @override
  Future<void> placeOrder(OrderEntity order) async {
    await _firestoreService.placeOrder(order.orderId, _mapToMap(order));
    await _firestoreService.logNotification(order.userId, {
      'id': 'not_${DateTime.now().millisecondsSinceEpoch}',
      'title': 'Order Placed!',
      'body': 'Your order #${order.orderId} was successfully placed. Total is ₹${order.totalAmount.toInt()}',
      'type': 'OrderUpdate',
      'isRead': false,
    });
  }

  @override
  Future<List<OrderEntity>> getOrders(String userId) async {
    try {
      final list = await _firestoreService.getOrders(userId);
      return list.map(_mapToEntity).toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<OrderEntity?> getOrderById(String orderId) async {
    final doc = await _firestoreService.getOrderById(orderId);
    if (doc == null) return null;
    return _mapToEntity(doc);
  }

  @override
  Stream<OrderEntity> streamOrderTracking(String orderId) {
    return _firestoreService.streamOrderTracking(orderId).map((doc) {
      final data = doc.data();
      if (data == null) throw Exception('Order not found');
      return _mapToEntity(data);
    });
  }

  @override
  Future<List<NotificationEntity>> getNotifications(String userId) async {
    try {
      final list = await _firestoreService.getNotifications(userId);
      return list.map((m) {
        return NotificationEntity(
          id: m['id'] as String? ?? '',
          title: m['title'] as String? ?? '',
          body: m['body'] as String? ?? '',
          type: m['type'] as String? ?? 'OrderUpdate',
          timestamp: m['timestamp'] != null
              ? DateTime.parse(m['timestamp'] as String)
              : DateTime.now(),
          isRead: m['isRead'] as bool? ?? false,
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }

  OrderEntity _mapToEntity(Map<String, dynamic> m) {
    final itemsList = List<Map<String, dynamic>>.from(m['items'] ?? const []);
    return OrderEntity(
      orderId: m['orderId'] as String? ?? '',
      userId: m['userId'] as String? ?? '',
      items: itemsList.map((item) {
        final prodMap = Map<String, dynamic>.from(item['product']);
        return CartItemEntity(
          product: ProductEntity(
            id: prodMap['id'] as String? ?? '',
            name: prodMap['name'] as String? ?? '',
            description: prodMap['description'] as String? ?? '',
            category: prodMap['category'] as String? ?? '',
            price: (prodMap['price'] as num? ?? 0.0).toDouble(),
            imageUrl: prodMap['imageUrl'] as String? ?? '',
            rating: (prodMap['rating'] as num? ?? 5.0).toDouble(),
            preparationTimeMinutes: prodMap['preparationTimeMinutes'] as int? ?? 10,
            isAvailable: prodMap['isAvailable'] as bool? ?? true,
            isVeg: prodMap['isVeg'] as bool? ?? true,
            isBestseller: prodMap['isBestseller'] as bool? ?? false,
          ),
          quantity: item['quantity'] as int? ?? 1,
          notes: item['notes'] as String?,
          selectedCustomizations: List<String>.from(item['selectedCustomizations'] ?? const []),
        );
      }).toList(),
      totalAmount: (m['totalAmount'] as num? ?? 0.0).toDouble(),
      paymentMethod: m['paymentMethod'] as String? ?? 'COD',
      paymentStatus: m['paymentStatus'] as String? ?? 'Pending',
      orderStatus: m['orderStatus'] as String? ?? 'Order Received',
      deliveryAddress: m['deliveryAddress'] as String? ?? '',
      deliveryCharge: (m['deliveryCharge'] as num? ?? 0.0).toDouble(),
      tax: (m['tax'] as num? ?? 0.0).toDouble(),
      estimatedDeliveryTime: m['estimatedDeliveryTime'] as String? ?? '25 mins',
      createdAt: m['createdAt'] != null
          ? DateTime.parse(m['createdAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> _mapToMap(OrderEntity order) {
    return {
      'orderId': order.orderId,
      'userId': order.userId,
      'items': order.items.map((item) => {
        'product': {
          'id': item.product.id,
          'name': item.product.name,
          'description': item.product.description,
          'category': item.product.category,
          'price': item.product.price,
          'imageUrl': item.product.imageUrl,
          'rating': item.product.rating,
          'preparationTimeMinutes': item.product.preparationTimeMinutes,
          'isAvailable': item.product.isAvailable,
          'isVeg': item.product.isVeg,
          'isBestseller': item.product.isBestseller,
        },
        'quantity': item.quantity,
        'notes': item.notes,
        'selectedCustomizations': item.selectedCustomizations,
      }).toList(),
      'totalAmount': order.totalAmount,
      'paymentMethod': order.paymentMethod,
      'paymentStatus': order.paymentStatus,
      'orderStatus': order.orderStatus,
      'deliveryAddress': order.deliveryAddress,
      'deliveryCharge': order.deliveryCharge,
      'tax': order.tax,
      'estimatedDeliveryTime': order.estimatedDeliveryTime,
      'createdAt': order.createdAt.toIso8601String(),
    };
  }
}
