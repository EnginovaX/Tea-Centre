import '../entities/product_entity.dart';

abstract class FavoriteRepository {
  Future<List<ProductEntity>> getFavorites(String userId);

  Future<void> addFavorite(String userId, ProductEntity product);

  Future<void> removeFavorite(String userId, String productId);

  Future<bool> isFavorite(String userId, String productId);
}
