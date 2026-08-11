import '../../domain/entities/cart_item_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/firestore_service.dart';
import '../datasources/session_manager.dart';

class CartRepositoryImpl implements CartRepository {
  final FirestoreService _firestoreService;
  final SessionManager _sessionManager;

  CartRepositoryImpl({
    required FirestoreService firestoreService,
    required SessionManager sessionManager,
  })  : _firestoreService = firestoreService,
        _sessionManager = sessionManager;

  @override
  Future<List<CartItemEntity>> getCart(String userId) async {
    final cached = _sessionManager.getCachedCart(userId);
    if (cached != null) {
      return cached.map(_mapToCartItemEntity).toList();
    }

    try {
      final doc = await _firestoreService.getCart(userId);
      if (doc != null && doc['items'] != null) {
        final list = List<Map<String, dynamic>>.from(doc['items']);
        await _sessionManager.cacheCart(userId, list);
        return list.map(_mapToCartItemEntity).toList();
      }
    } catch (_) {
      if (cached != null) {
        return cached.map(_mapToCartItemEntity).toList();
      }
    }
    return [];
  }

  @override
  Future<void> saveCart(String userId, List<CartItemEntity> items) async {
    final rawList = items.map(_mapToMap).toList();
    await _firestoreService.saveCart(userId, {'items': rawList});
    await _sessionManager.cacheCart(userId, rawList);
  }

  @override
  Future<void> clearCart(String userId) async {
    await _firestoreService.clearCart(userId);
    await _sessionManager.clearCachedCart(userId);
  }

  CartItemEntity _mapToCartItemEntity(Map<String, dynamic> m) {
    final prodMap = Map<String, dynamic>.from(m['product']);
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
      quantity: m['quantity'] as int? ?? 1,
      notes: m['notes'] as String?,
      selectedCustomizations: List<String>.from(m['selectedCustomizations'] ?? const []),
    );
  }

  Map<String, dynamic> _mapToMap(CartItemEntity item) {
    return {
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
    };
  }
}
