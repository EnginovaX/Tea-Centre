import 'cart_item_entity.dart';

class OrderEntity {
  final String orderId;
  final String userId;
  final List<CartItemEntity> items;
  final double totalAmount;
  final String paymentMethod; // "COD", "Razorpay", "UPI", "GPay", "Paytm"
  final String paymentStatus; // "Pending", "Paid", "Failed"
  final String orderStatus; // "Order Received", "Preparing", "Ready", "Out for Delivery", "Delivered", "Completed"
  final String deliveryAddress;
  final double deliveryCharge;
  final double tax;
  final String estimatedDeliveryTime;
  final DateTime createdAt;

  const OrderEntity({
    required this.orderId,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.orderStatus,
    required this.deliveryAddress,
    required this.deliveryCharge,
    required this.tax,
    required this.estimatedDeliveryTime,
    required this.createdAt,
  });

  OrderEntity copyWith({
    String? orderId,
    String? userId,
    List<CartItemEntity>? items,
    double? totalAmount,
    String? paymentMethod,
    String? paymentStatus,
    String? orderStatus,
    String? deliveryAddress,
    double? deliveryCharge,
    double? tax,
    String? estimatedDeliveryTime,
    DateTime? createdAt,
  }) {
    return OrderEntity(
      orderId: orderId ?? this.orderId,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      orderStatus: orderStatus ?? this.orderStatus,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      deliveryCharge: deliveryCharge ?? this.deliveryCharge,
      tax: tax ?? this.tax,
      estimatedDeliveryTime: estimatedDeliveryTime ?? this.estimatedDeliveryTime,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
