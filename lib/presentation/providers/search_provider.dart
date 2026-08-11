import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/product_entity.dart';
import 'menu_provider.dart';

class SearchState {
  final String query;
  final List<ProductEntity> results;
  final List<String> popularSearches;
  final List<String> recentSearches;

  const SearchState({
    this.query = '',
    this.results = const [],
    this.popularSearches = const ['Masala Chai', 'Samosa', 'Ginger Tea', 'Cold Coffee'],
    this.recentSearches = const [],
  });

  SearchState copyWith({
    String? query,
    List<ProductEntity>? results,
    List<String>? popularSearches,
    List<String>? recentSearches,
  }) {
    return SearchState(
      query: query ?? this.query,
      results: results ?? this.results,
      popularSearches: popularSearches ?? this.popularSearches,
      recentSearches: recentSearches ?? this.recentSearches,
    );
  }
}

class SearchNotifier extends StateNotifier<SearchState> {
  final Ref _ref;

  SearchNotifier(this._ref) : super(const SearchState());

  void search(String query) {
    if (query.trim().isEmpty) {
      state = state.copyWith(query: '', results: []);
      return;
    }

    final menu = _ref.read(menuProvider);
    final filtered = menu.products.where((p) {
      final nameMatches = p.name.toLowerCase().contains(query.toLowerCase());
      final descMatches = p.description.toLowerCase().contains(query.toLowerCase());
      return nameMatches || descMatches;
    }).toList();

    state = state.copyWith(query: query, results: filtered);
  }

  void addRecentSearch(String item) {
    final list = List<String>.from(state.recentSearches);
    if (!list.contains(item)) {
      list.insert(0, item);
      if (list.length > 5) list.removeLast();
    }
    state = state.copyWith(recentSearches: list);
  }

  void clearRecentSearches() {
    state = state.copyWith(recentSearches: []);
  }
}

final searchProvider = StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  return SearchNotifier(ref);
});
