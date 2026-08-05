import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/menu_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';
import '../../core/routes/app_routes.dart';
import '../widgets/app_card.dart';
import '../../domain/entities/product_entity.dart';

class ProductListingScreen extends ConsumerWidget {
  const ProductListingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuState = ref.watch(menuProvider);
    final authState = ref.watch(authProvider);

    final selectedCategoryProducts = menuState.selectedCategory == 'All'
        ? menuState.products
        : menuState.products.where((p) => p.category == menuState.selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('${menuState.selectedCategory} Menu'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_basket),
            onPressed: () {
              context.push(AppRoutes.cart);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Horizontal categories scroller list
            SizedBox(
              height: 56,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: menuState.categories.length + 1,
                itemBuilder: (context, idx) {
                  final catName = idx == 0 ? 'All' : menuState.categories[idx - 1].name;
                  final isSel = menuState.selectedCategory == catName;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(catName),
                      selected: isSel,
                      onSelected: (selected) {
                        if (selected) {
                          ref.read(menuProvider.notifier).selectCategory(catName);
                        }
                      },
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: selectedCategoryProducts.isEmpty
                  ? const Center(child: Text('No products available in this category'))
                  : GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.72,
                      ),
                      itemCount: selectedCategoryProducts.length,
                      itemBuilder: (context, idx) {
                        final prod = selectedCategoryProducts[idx];
                        return _buildProductCard(context, ref, prod, authState.uid ?? 'guest');
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, WidgetRef ref, ProductEntity prod, String userId) {
    final theme = Theme.of(context);
    return AppCard(
      onTap: () {
        context.push(AppRoutes.productDetails, extra: prod);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  prod.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => Container(
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.fastfood, size: 40, color: Colors.grey),
                  ),
                ),
                if (prod.isBestseller)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'BESTSELLER',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  prod.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.headlineMedium?.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.circle,
                      size: 10,
                      color: prod.isVeg ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      prod.isVeg ? 'Veg' : 'Non-Veg',
                      style: theme.textTheme.labelMedium?.copyWith(fontSize: 10),
                    ),
                    const Spacer(),
                    const Icon(Icons.star, size: 12, color: Colors.amber),
                    Text(
                      ' ${prod.rating}',
                      style: theme.textTheme.labelMedium?.copyWith(fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '₹${prod.price.toInt()}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    IconButton.filled(
                      onPressed: () {
                        ref.read(cartProvider(userId).notifier).addItem(prod);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${prod.name} added to cart!'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add, size: 16),
                      style: IconButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
