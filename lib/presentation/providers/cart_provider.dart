import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/entities/offer_entity.dart';
import 'dependency_providers.dart';

class CartState {
  final List<CartItemEntity> items;
  final OfferEntity? appliedOffer;
  final bool isLoading;

  const CartState({
    this.items = const [],
    this.appliedOffer,
    this.isLoading = false,
  });

  double get subtotal => items.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get discountAmount {
    if (appliedOffer == null) return 0.0;
    final calc = subtotal * (appliedOffer!.discountPercent / 100);
    return calc > appliedOffer!.maxDiscountAmount ? appliedOffer!.maxDiscountAmount : calc;
  }

  double get deliveryCharge => subtotal > 0 && subtotal < 150 ? 20.0 : 0.0;

  double get tax => subtotal * 0.05; // 5% GST

  double get totalAmount {
    final calc = subtotal - discountAmount + deliveryCharge + tax;
    return calc < 0 ? 0 : calc;
  }

  CartState copyWith({
    List<CartItemEntity>? items,
    OfferEntity? appliedOffer,
    bool? isLoading,
  }) {
    return CartState(
      items: items ?? this.items,
      appliedOffer: appliedOffer ?? this.appliedOffer,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class CartNotifier extends StateNotifier<CartState> {
  final Ref _ref;
  final String _userId;

  CartNotifier(this._ref, this._userId) : super(const CartState()) {
    _loadCart();
  }

  Future<void> _loadCart() async {
    state = state.copyWith(isLoading: true);
    try {
      final items = await _ref.read(cartRepositoryProvider).getCart(_userId);
      state = CartState(items: items, isLoading: false);
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> addItem(ProductEntity product, {int quantity = 1, List<String> customizations = const [], String? notes}) async {
    final updatedItems = List<CartItemEntity>.from(state.items);
    final idx = updatedItems.indexWhere((item) => item.product.id == product.id);

    if (idx >= 0) {
      final oldItem = updatedItems[idx];
      updatedItems[idx] = oldItem.copyWith(quantity: oldItem.quantity + quantity);
    } else {
      updatedItems.add(CartItemEntity(
        product: product,
        quantity: quantity,
        selectedCustomizations: customizations,
        notes: notes,
      ));
    }

    state = state.copyWith(items: updatedItems);
    await _ref.read(cartRepositoryProvider).saveCart(_userId, updatedItems);
  }

  Future<void> removeItem(String productId) async {
    final updatedItems = List<CartItemEntity>.from(state.items);
    updatedItems.removeWhere((item) => item.product.id == productId);

    state = state.copyWith(items: updatedItems);
    await _ref.read(cartRepositoryProvider).saveCart(_userId, updatedItems);
  }

  Future<void> increaseQuantity(String productId) async {
    final updatedItems = List<CartItemEntity>.from(state.items);
    final idx = updatedItems.indexWhere((item) => item.product.id == productId);

    if (idx >= 0) {
      final oldItem = updatedItems[idx];
      updatedItems[idx] = oldItem.copyWith(quantity: oldItem.quantity + 1);
      state = state.copyWith(items: updatedItems);
      await _ref.read(cartRepositoryProvider).saveCart(_userId, updatedItems);
    }
  }

  Future<void> decreaseQuantity(String productId) async {
    final updatedItems = List<CartItemEntity>.from(state.items);
    final idx = updatedItems.indexWhere((item) => item.product.id == productId);

    if (idx >= 0) {
      final oldItem = updatedItems[idx];
      if (oldItem.quantity <= 1) {
        updatedItems.removeAt(idx);
      } else {
        updatedItems[idx] = oldItem.copyWith(quantity: oldItem.quantity - 1);
      }
      state = state.copyWith(items: updatedItems);
      await _ref.read(cartRepositoryProvider).saveCart(_userId, updatedItems);
    }
  }

  void applyOffer(OfferEntity offer) {
    state = state.copyWith(appliedOffer: offer);
  }

  void removeOffer() {
    state = state.copyWith(appliedOffer: null);
  }

  Future<void> clearCart() async {
    state = const CartState();
    await _ref.read(cartRepositoryProvider).clearCart(_userId);
  }
}

final cartProvider = StateNotifierProvider.family<CartNotifier, CartState, String>((ref, userId) {
  return CartNotifier(ref, userId);
});
