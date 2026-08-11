import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/product_entity.dart';

class ProductNotifier extends StateNotifier<List<ProductEntity>> {
  ProductNotifier() : super([]);

  // Mock similar products logic
  List<ProductEntity> getSimilarProducts(ProductEntity product, List<ProductEntity> allProducts) {
    return allProducts
        .where((p) => p.id != product.id && p.category == product.category)
        .toList();
  }
}

final productProvider = StateNotifierProvider<ProductNotifier, List<ProductEntity>>((ref) {
  return ProductNotifier();
});
