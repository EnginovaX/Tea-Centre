import '../entities/product_entity.dart';
import '../entities/category_entity.dart';
import '../entities/offer_entity.dart';

abstract class MenuRepository {
  Future<List<CategoryEntity>> getCategories();

  Future<List<ProductEntity>> getProducts();

  Future<List<ProductEntity>> getProductsByCategory(String categoryName);

  Future<List<OfferEntity>> getOffers();
}
