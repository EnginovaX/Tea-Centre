import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/cart_provider.dart';
import '../providers/checkout_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/order_provider.dart';
import '../../domain/entities/order_entity.dart';
import '../../core/routes/app_routes.dart';
import '../widgets/app_button.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  String _selectedPaymentMethod = 'COD';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userId = ref.watch(authProvider).uid ?? 'guest';
    final cartState = ref.watch(cartProvider(userId));
    final checkoutState = ref.watch(checkoutProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Fulfillment Option', style: theme.textTheme.headlineMedium),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('Home Delivery', style: TextStyle(fontWeight: FontWeight.bold)),
                      selected: checkoutState.isDelivery,
                      onSelected: (val) {
                        ref.read(checkoutProvider.notifier).setFulfillmentType(isDelivery: true);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('Self Pickup', style: TextStyle(fontWeight: FontWeight.bold)),
                      selected: !checkoutState.isDelivery,
                      onSelected: (val) {
                        ref.read(checkoutProvider.notifier).setFulfillmentType(isDelivery: false);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text('Delivery Address', style: theme.textTheme.headlineMedium),
              const SizedBox(height: 12),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.location_on),
                  title: const Text('Default Address'),
                  subtitle: const Text('Flat 402, Saffron Heights, Mumbai - 400001'),
                  trailing: TextButton(
                    onPressed: () {
                      context.push(AppRoutes.address);
                    },
                    child: const Text('Change'),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text('Payment Method', style: theme.textTheme.headlineMedium),
              const SizedBox(height: 12),
              Card(
                child: Column(
                  children: [
                    RadioListTile<String>(
                      title: const Text('Cash on Delivery (COD)'),
                      value: 'COD',
                      groupValue: _selectedPaymentMethod,
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _selectedPaymentMethod = val;
                          });
                        }
                      },
                    ),
                    const Divider(height: 1),
                    RadioListTile<String>(
                      title: const Text('UPI (GPay / Paytm / PhonePe)'),
                      value: 'UPI',
                      groupValue: _selectedPaymentMethod,
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _selectedPaymentMethod = val;
                          });
                        }
                      },
                    ),
                    const Divider(height: 1),
                    RadioListTile<String>(
                      title: const Text('Razorpay (Cards / NetBanking)'),
                      value: 'RAZORPAY',
                      groupValue: _selectedPaymentMethod,
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _selectedPaymentMethod = val;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              AppButton(
                label: 'Place Order (₹${cartState.totalAmount.toInt()})',
                onPressed: () async {
                  final orderId = 'tc_${DateTime.now().millisecondsSinceEpoch}';
                  final order = OrderEntity(
                    orderId: orderId,
                    userId: userId,
                    items: cartState.items,
                    totalAmount: cartState.totalAmount,
                    paymentMethod: _selectedPaymentMethod,
                    paymentStatus: _selectedPaymentMethod == 'COD' ? 'Pending' : 'Paid',
                    orderStatus: 'Order Received',
                    deliveryAddress: 'Flat 402, Saffron Heights, Mumbai - 400001',
                    deliveryCharge: cartState.deliveryCharge,
                    tax: cartState.tax,
                    estimatedDeliveryTime: '25 mins',
                    createdAt: DateTime.now(),
                  );

                  await ref.read(orderProvider.notifier).placeOrder(order);
                  // Clear shopping cart
                  await ref.read(cartProvider(userId).notifier).clearCart();

                  if (context.mounted) {
                    context.go(AppRoutes.success, extra: orderId);
                  }
                },
                fullWidth: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
