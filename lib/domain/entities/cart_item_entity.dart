import 'product_entity.dart';

class CartItemEntity {
  final ProductEntity product;
  final int quantity;
  final String? notes;
  final List<String> selectedCustomizations;

  const CartItemEntity({
    required this.product,
    required this.quantity,
    this.notes,
    this.selectedCustomizations = const [],
  });

  double get totalPrice => product.price * quantity;

  CartItemEntity copyWith({
    ProductEntity? product,
    int? quantity,
    String? notes,
    List<String>? selectedCustomizations,
  }) {
    return CartItemEntity(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      notes: notes ?? this.notes,
      selectedCustomizations: selectedCustomizations ?? this.selectedCustomizations,
    );
  }
}
