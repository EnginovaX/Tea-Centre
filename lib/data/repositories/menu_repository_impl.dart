import '../../domain/entities/category_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/entities/offer_entity.dart';
import '../../domain/repositories/menu_repository.dart';
import '../datasources/firestore_service.dart';
import '../datasources/session_manager.dart';

class MenuRepositoryImpl implements MenuRepository {
  final FirestoreService _firestoreService;
  final SessionManager _sessionManager;

  MenuRepositoryImpl({
    required FirestoreService firestoreService,
    required SessionManager sessionManager,
  })  : _firestoreService = firestoreService,
        _sessionManager = sessionManager;

  @override
  Future<List<CategoryEntity>> getCategories() async {
    final cached = _sessionManager.getCachedCategories();
    if (cached != null) {
      return cached.map(_mapToCategoryEntity).toList();
    }

    try {
      final data = await _firestoreService.getCategories();
      await _sessionManager.cacheCategories(data);
      return data.map(_mapToCategoryEntity).toList();
    } catch (_) {
      if (cached != null) {
        return cached.map(_mapToCategoryEntity).toList();
      }
      return _getPlaceholderCategories();
    }
  }

  @override
  Future<List<ProductEntity>> getProducts() async {
    final cached = _sessionManager.getCachedProducts();
    if (cached != null) {
      return cached.map(_mapToProductEntity).toList();
    }

    try {
      final data = await _firestoreService.getProducts();
      await _sessionManager.cacheProducts(data);
      return data.map(_mapToProductEntity).toList();
    } catch (_) {
      if (cached != null) {
        return cached.map(_mapToProductEntity).toList();
      }
      return _getPlaceholderProducts();
    }
  }

  @override
  Future<List<ProductEntity>> getProductsByCategory(String categoryName) async {
    final all = await getProducts();
    return all.where((p) => p.category.toLowerCase() == categoryName.toLowerCase()).toList();
  }

  @override
  Future<List<OfferEntity>> getOffers() async {
    try {
      final data = await _firestoreService.getOffers();
      return data.map(_mapToOfferEntity).toList();
    } catch (_) {
      return const [
        OfferEntity(
          code: 'CHAI50',
          description: 'Get 50% discount up to ₹50 on cutting chai combos.',
          discountPercent: 50,
          maxDiscountAmount: 50,
        ),
        OfferEntity(
          code: 'SAMOSAFREE',
          description: 'Flat 20% discount on order above ₹100.',
          discountPercent: 20,
          maxDiscountAmount: 100,
        ),
      ];
    }
  }

  CategoryEntity _mapToCategoryEntity(Map<String, dynamic> m) {
    return CategoryEntity(
      id: m['id'] as String? ?? '',
      name: m['name'] as String? ?? '',
      iconUrl: m['iconUrl'] as String? ?? '',
    );
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

  OfferEntity _mapToOfferEntity(Map<String, dynamic> m) {
    return OfferEntity(
      code: m['code'] as String? ?? '',
      description: m['description'] as String? ?? '',
      discountPercent: (m['discountPercent'] as num? ?? 0).toDouble(),
      maxDiscountAmount: (m['maxDiscountAmount'] as num? ?? 0).toDouble(),
    );
  }

  List<CategoryEntity> _getPlaceholderCategories() {
    return const [
      CategoryEntity(id: 'c1', name: 'Chai', iconUrl: 'local_cafe'),
      CategoryEntity(id: 'c2', name: 'Coffee', iconUrl: 'coffee'),
      CategoryEntity(id: 'c3', name: 'Snacks', iconUrl: 'restaurant'),
      CategoryEntity(id: 'c4', name: 'Combos', iconUrl: 'lunch_dining'),
    ];
  }

  List<ProductEntity> _getPlaceholderProducts() {
    return const [
      ProductEntity(
        id: 'p1',
        name: 'Masala Chai',
        description: 'Our signature blend with fresh aromatic Indian spices.',
        category: 'Chai',
        price: 30.0,
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAYWvOijcR0yFQlmrE_rRrpkbHJsi6k6w7voOzkAyLQfys9rDDHuFiVDKDjt4-CCroEplJPMPKvdPM2cJIRGWHCPPlggJWXVU2N3kR0nYwBVjVf5Ia59fDa3ANDBJrtwleaAr4gIpPccVRyPmrmc2O0Rzy2ow3Fe_gyYCQWfKeuaDK0LP4v4_Vm-_TYDwi3yKhjSDey3sV5FvAeQGiuurzAL_kjRXErJHAOfbmwi3rPI5Z2ENy1Ys3p',
        rating: 4.8,
        preparationTimeMinutes: 5,
        isAvailable: true,
        isVeg: true,
        isBestseller: true,
        ingredients: ['Assam Tea Leaves', 'Fresh Milk', 'Ginger', 'Cardamom', 'Secret Masala'],
        customizations: ['Extra Ginger', 'Less Sugar', 'Without Milk'],
      ),
      ProductEntity(
        id: 'p2',
        name: 'Punjabi Samosa',
        description: 'Crispy golden triangular pastry filled with spiced potato and peas.',
        category: 'Snacks',
        price: 25.0,
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCLLN0S-DmSgQtJTnEwR9euvprMPYYWDos4CEEFQoVL6C3uaA5EIiiuOPKEjE_geXBYrt_Xv0nHlqyLKICfn_PDkI-86YBPWMOA9-FtDClbadlWbC-FCuxnFaZKDouUyt17McGUbMJBO3qzc1ELmRrT6iVe_FGkBBZjffAO4j1wHmi3LXxQrY8_owIDhOTXuByp4eT26yzSl9Y0tWCqFJseocJ-8nMj-uAfrVF9djiQa9RdalGVJbtX',
        rating: 4.7,
        preparationTimeMinutes: 7,
        isAvailable: true,
        isVeg: true,
        isBestseller: true,
        ingredients: ['Refined Flour', 'Potatoes', 'Green Peas', 'Garam Masala', 'Coriander'],
        customizations: ['Extra Mint Chutney', 'Sweet Tamarind Chutney'],
      ),
    ];
  }
}
