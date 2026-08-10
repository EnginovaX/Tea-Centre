import '../entities/cart_item_entity.dart';

abstract class CartRepository {
  Future<List<CartItemEntity>> getCart(String userId);

  Future<void> saveCart(String userId, List<CartItemEntity> items);

  Future<void> clearCart(String userId);
}
