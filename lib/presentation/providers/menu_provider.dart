import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/entities/offer_entity.dart';
import 'dependency_providers.dart';

class MenuState {
  final List<CategoryEntity> categories;
  final List<ProductEntity> products;
  final List<OfferEntity> offers;
  final String selectedCategory;
  final bool isLoading;

  const MenuState({
    this.categories = const [],
    this.products = const [],
    this.offers = const [],
    this.selectedCategory = 'All',
    this.isLoading = false,
  });

  MenuState copyWith({
    List<CategoryEntity>? categories,
    List<ProductEntity>? products,
    List<OfferEntity>? offers,
    String? selectedCategory,
    bool? isLoading,
  }) {
    return MenuState(
      categories: categories ?? this.categories,
      products: products ?? this.products,
      offers: offers ?? this.offers,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class MenuNotifier extends StateNotifier<MenuState> {
  final Ref _ref;

  MenuNotifier(this._ref) : super(const MenuState()) {
    loadMenu();
  }

  Future<void> loadMenu() async {
    state = state.copyWith(isLoading: true);
    try {
      final repo = _ref.read(menuRepositoryProvider);
      final categories = await repo.getCategories();
      final products = await repo.getProducts();
      final offers = await repo.getOffers();

      state = MenuState(
        categories: categories,
        products: products,
        offers: offers,
        selectedCategory: 'All',
        isLoading: false,
      );
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }

  void selectCategory(String category) {
    state = state.copyWith(selectedCategory: category);
  }
}

final menuProvider = StateNotifierProvider<MenuNotifier, MenuState>((ref) {
  return MenuNotifier(ref);
});
