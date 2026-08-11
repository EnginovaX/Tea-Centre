import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';
import '../../core/routes/app_routes.dart';
import '../widgets/app_button.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final userId = ref.watch(authProvider).uid ?? 'guest';
    final cartState = ref.watch(cartProvider(userId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Shopping Cart'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: cartState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : cartState.items.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.shopping_basket, size: 80, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          'Your cart is empty',
                          style: theme.textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 24),
                        AppButton(
                          label: 'Browse Menu',
                          onPressed: () {
                            context.go(AppRoutes.home);
                          },
                        ),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: cartState.items.length,
                          itemBuilder: (context, idx) {
                            final item = cartState.items[idx];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: ListTile(
                                leading: Image.network(
                                  item.product.imageUrl,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (c, e, s) => Container(
                                    width: 50,
                                    height: 50,
                                    color: Colors.grey.shade200,
                                    child: const Icon(Icons.fastfood, size: 24, color: Colors.grey),
                                  ),
                                ),
                                title: Text(item.product.name),
                                subtitle: Text('₹${item.product.price.toInt()} each'),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove_circle_outline),
                                      onPressed: () {
                                        ref.read(cartProvider(userId).notifier).decreaseQuantity(item.product.id);
                                      },
                                    ),
                                    Text(
                                      '${item.quantity}',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add_circle_outline),
                                      onPressed: () {
                                        ref.read(cartProvider(userId).notifier).increaseQuantity(item.product.id);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildPriceRow('Subtotal', '₹${cartState.subtotal.toInt()}', theme),
                            if (cartState.discountAmount > 0)
                              _buildPriceRow('Coupon Discount', '-₹${cartState.discountAmount.toInt()}', theme, color: Colors.green),
                            _buildPriceRow('Taxes & GST (5%)', '₹${cartState.tax.toInt()}', theme),
                            _buildPriceRow('Delivery Charge', '₹${cartState.deliveryCharge.toInt()}', theme),
                            const Divider(height: 24),
                            _buildPriceRow('Total Amount', '₹${cartState.totalAmount.toInt()}', theme, isBold: true),
                            const SizedBox(height: 24),
                            AppButton(
                              label: 'Proceed to Checkout',
                              onPressed: () {
                                context.push(AppRoutes.checkout);
                              },
                              fullWidth: true,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
      ),
    );
  }

  Widget _buildPriceRow(String title, String val, ThemeData theme, {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: isBold
                ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
                : TextStyle(color: theme.colorScheme.onSurfaceVariant),
          ),
          Text(
            val,
            style: isBold
                ? TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: theme.colorScheme.primary)
                : TextStyle(color: color ?? theme.colorScheme.onSurface),
          ),
        ],
      ),
    );
  }
}
