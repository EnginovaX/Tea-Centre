import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/routes/app_routes.dart';
import '../providers/auth_provider.dart';
import '../providers/menu_provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/app_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final authState = ref.watch(authProvider);
    final menuState = ref.watch(menuProvider);
    final userId = authState.uid ?? 'guest';
    final cartState = ref.watch(cartProvider(userId));

    return Scaffold(
      appBar: AppBar(
        title: Image.network(
          'https://lh3.googleusercontent.com/aida-public/AB6AXuChEWCpDY1-thlmKqo2Gh6KsQ_-A6bw2ZzT61zs6HW2NDgy7LnSZ2RXeoO511zKOIIZpMD4Ca7z_sZIN-1UCioa8eUWnFUpxG3JSH-uJzOyjzUpKI8OEdPsogfWvx1icZdxl4ura8UpbDkOqi8Z82mdGl7u4DQYyKQ3o7Z7RJuhKjU8gyQmaSgl15Oml2sBxfwzczQd_MeZnax5ukGWakFhQlTJjwMCn5DB5r-Ei6saBmWk2XM8ONwr',
          height: 36,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Badge(
              label: Text('${cartState.items.length}'),
              child: const Icon(Icons.shopping_basket),
            ),
            onPressed: () {
              context.push(AppRoutes.cart);
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.push(AppRoutes.settings);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: menuState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Greeting Banner
                    Text(
                      'Hi, Rahul!',
                      style: theme.textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'What are you craving today?',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Search Card
                    GestureDetector(
                      onTap: () {
                        // Open listing/search
                        context.push(AppRoutes.productListing);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey.shade900 : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.1)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search, color: Colors.grey),
                            const SizedBox(width: 12),
                            Text(
                              'Search for chai, snacks...',
                              style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Store details & fulfillment banner
                    AppCard(
                      child: Row(
                        children: [
                          const Icon(Icons.store, color: Colors.orange, size: 28),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Tea Centre Tapri (Mumbai Branch)',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Working hours: 7 AM - 11 PM',
                                  style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                                ),
                              ],
                            ),
                          ),
                          const Badge(label: Text('Open')),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Categories List Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Popular Choices', style: theme.textTheme.headlineMedium),
                        TextButton(
                          onPressed: () {
                            context.push(AppRoutes.productListing);
                          },
                          child: const Text('View All'),
                        )
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Bento Grid items
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: menuState.products.take(2).length,
                      itemBuilder: (context, idx) {
                        final prod = menuState.products[idx];
                        return AppCard(
                          onTap: () {
                            context.push(AppRoutes.productDetails, extra: prod);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: Image.network(
                                  prod.imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (c, e, s) => Container(
                                    color: Colors.grey.shade200,
                                    child: const Icon(Icons.fastfood, size: 40, color: Colors.grey),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      prod.name,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('₹${prod.price.toInt()}', style: TextStyle(color: theme.colorScheme.primary)),
                                        const Icon(Icons.add_circle, color: Colors.orange, size: 24),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    // Promo offer banner
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.local_offer, color: Colors.orange, size: 32),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Evening Special Offer!',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                Text(
                                  'Use Coupon CHAI50 to get up to 50% discount.',
                                  style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Alerts'),
        ],
        onTap: (idx) {
          if (idx == 1) {
            context.push(AppRoutes.favorites);
          } else if (idx == 2) {
            context.push(AppRoutes.orderHistory);
          } else if (idx == 3) {
            context.push(AppRoutes.notifications);
          }
        },
      ),
    );
  }
}
