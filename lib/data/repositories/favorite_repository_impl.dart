import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/favorite_repository.dart';
import '../datasources/firestore_service.dart';
import '../datasources/session_manager.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  final FirestoreService _firestoreService;
  final SessionManager _sessionManager;

  FavoriteRepositoryImpl({
    required FirestoreService firestoreService,
    required SessionManager sessionManager,
  })  : _firestoreService = firestoreService,
        _sessionManager = sessionManager;

  @override
  Future<List<ProductEntity>> getFavorites(String userId) async {
    final cached = _sessionManager.getCachedFavorites(userId);
    if (cached != null) {
      return cached.map(_mapToProductEntity).toList();
    }

    try {
      final data = await _firestoreService.getFavorites(userId);
      final list = data.map((item) => Map<String, dynamic>.from(item['product'])).toList();
      await _sessionManager.cacheFavorites(userId, list);
      return list.map(_mapToProductEntity).toList();
    } catch (_) {
      if (cached != null) {
        return cached.map(_mapToProductEntity).toList();
      }
      return [];
    }
  }

  @override
  Future<void> addFavorite(String userId, ProductEntity product) async {
    final rawProd = _mapToMap(product);
    await _firestoreService.addFavorite(userId, product.id, {'product': rawProd});

    final cachedList = _sessionManager.getCachedFavorites(userId) ?? [];
    cachedList.removeWhere((item) => item['id'] == product.id);
    cachedList.add(rawProd);
    await _sessionManager.cacheFavorites(userId, cachedList);
  }

  @override
  Future<void> removeFavorite(String userId, String productId) async {
    await _firestoreService.removeFavorite(userId, productId);

    final cachedList = _sessionManager.getCachedFavorites(userId) ?? [];
    cachedList.removeWhere((item) => item['id'] == productId);
    await _sessionManager.cacheFavorites(userId, cachedList);
  }

  @override
  Future<bool> isFavorite(String userId, String productId) async {
    try {
      return await _firestoreService.isFavorite(userId, productId);
    } catch (_) {
      final cachedList = _sessionManager.getCachedFavorites(userId) ?? [];
      return cachedList.any((item) => item['id'] == productId);
    }
  }

  ProductEntity _mapToProductEntity(Map<String, dynamic> m) {
    return ProductEntity(
      id: m['id'] as String? ?? '',
      name: m['name'] as String? ?? '',
      description: m['description'] as String? ?? '',
      category: m['category'] as String? ?? '',
      price: (m['price'] as num? ?? 0.0).toDouble(),
      imageUrl: m['imageUrl'] as String? ?? '',
      rating: (m['rating'] as num? ?? 5.0).toDouble(),
      preparationTimeMinutes: m['preparationTimeMinutes'] as int? ?? 10,
      isAvailable: m['isAvailable'] as bool? ?? true,
      isVeg: m['isVeg'] as bool? ?? true,
      isBestseller: m['isBestseller'] as bool? ?? false,
      ingredients: List<String>.from(m['ingredients'] ?? const []),
      customizations: List<String>.from(m['customizations'] ?? const []),
    );
  }

  Map<String, dynamic> _mapToMap(ProductEntity p) {
    return {
      'id': p.id,
      'name': p.name,
      'description': p.description,
      'category': p.category,
      'price': p.price,
      'imageUrl': p.imageUrl,
      'rating': p.rating,
      'preparationTimeMinutes': p.preparationTimeMinutes,
      'isAvailable': p.isAvailable,
      'isVeg': p.isVeg,
      'isBestseller': p.isBestseller,
      'ingredients': p.ingredients,
      'customizations': p.customizations,
    };
  }
}
