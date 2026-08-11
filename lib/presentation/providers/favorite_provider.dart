import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/product_entity.dart';
import 'dependency_providers.dart';

class FavoriteNotifier extends StateNotifier<AsyncValue<List<ProductEntity>>> {
  final Ref _ref;

  FavoriteNotifier(this._ref) : super(const AsyncValue.loading());

  Future<void> loadFavorites(String userId) async {
    state = const AsyncValue.loading();
    try {
      final list = await _ref.read(favoriteRepositoryProvider).getFavorites(userId);
      state = AsyncValue.data(list);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addFavorite(String userId, ProductEntity product) async {
    try {
      await _ref.read(favoriteRepositoryProvider).addFavorite(userId, product);
      await loadFavorites(userId);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> removeFavorite(String userId, String productId) async {
    try {
      await _ref.read(favoriteRepositoryProvider).removeFavorite(userId, productId);
      await loadFavorites(userId);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<bool> isFavorite(String userId, String productId) async {
    return await _ref.read(favoriteRepositoryProvider).isFavorite(userId, productId);
  }
}

final favoriteProvider = StateNotifierProvider<FavoriteNotifier, AsyncValue<List<ProductEntity>>>((ref) {
  return FavoriteNotifier(ref);
});
