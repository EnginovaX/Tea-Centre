class ProductEntity {
  final String id;
  final String name;
  final String description;
  final String category;
  final double price;
  final String imageUrl;
  final double rating;
  final int preparationTimeMinutes; // in minutes
  final bool isAvailable;
  final bool isVeg;
  final bool isBestseller;
  final List<String> ingredients;
  final List<String> customizations; // e.g. "Less Sugar", "Extra Cardamom"

  const ProductEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.imageUrl,
    required this.rating,
    required this.preparationTimeMinutes,
    required this.isAvailable,
    required this.isVeg,
    required this.isBestseller,
    this.ingredients = const [],
    this.customizations = const [],
  });

  ProductEntity copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    double? price,
    String? imageUrl,
    double? rating,
    int? preparationTimeMinutes,
    bool? isAvailable,
    bool? isVeg,
    bool? isBestseller,
    List<String>? ingredients,
    List<String>? customizations,
  }) {
    return ProductEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      preparationTimeMinutes: preparationTimeMinutes ?? this.preparationTimeMinutes,
      isAvailable: isAvailable ?? this.isAvailable,
      isVeg: isVeg ?? this.isVeg,
      isBestseller: isBestseller ?? this.isBestseller,
      ingredients: ingredients ?? this.ingredients,
      customizations: customizations ?? this.customizations,
    );
  }
}
