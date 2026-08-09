import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/coupon_entity.dart';
import '../providers/coupon_provider.dart';

class AdminCouponsScreen extends ConsumerStatefulWidget {
  const AdminCouponsScreen({super.key});

  @override
  ConsumerState<AdminCouponsScreen> createState() => _AdminCouponsScreenState();
}

class _AdminCouponsScreenState extends ConsumerState<AdminCouponsScreen> {
  final _codeController = TextEditingController();
  final _discountController = TextEditingController();
  final _minSpendController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    _discountController.dispose();
    _minSpendController.dispose();
    super.dispose();
  }

  void _generateCoupon() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Generate Promo Coupon',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _codeController,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(labelText: 'Coupon Code (e.g. FESTIVE25)'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _discountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Discount Percentage (%)'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _minSpendController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Minimum Spend Limit (₹)'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (_codeController.text.isNotEmpty &&
                      _discountController.text.isNotEmpty &&
                      _minSpendController.text.isNotEmpty) {
                    final newCoupon = CouponEntity(
                      code: _codeController.text.toUpperCase(),
                      description: 'Custom admin coupon code',
                      type: CouponType.percentage,
                      value: double.tryParse(_discountController.text) ?? 10.0,
                      minOrderAmount: double.tryParse(_minSpendController.text) ?? 100.0,
                      expiryDate: DateTime.now().add(const Duration(days: 30)),
                      isActive: true,
                    );
                    await ref.read(couponProvider.notifier).createAndPublishCoupon(newCoupon);

                    _codeController.clear();
                    _discountController.clear();
                    _minSpendController.clear();
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Coupon Generated Successfully!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  }
                },
                child: const Text('Generate & Publish'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final couponsState = ref.watch(couponProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Coupon Discount Engine',
          style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _generateCoupon,
        icon: const Icon(Icons.add_card),
        label: const Text('Generate Coupon'),
      ),
      body: couponsState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (list) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: list.length,
          itemBuilder: (context, index) {
            final coupon = list[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            coupon.code,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onPrimaryContainer,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Discount: ${coupon.value.toInt()}% Off',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Min Spend Requirement: ₹${coupon.minOrderAmount}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          coupon.isActive ? 'Active' : 'Disabled',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: coupon.isActive ? Colors.green : Colors.grey,
                          ),
                        ),
                        Switch(
                          value: coupon.isActive,
                          onChanged: (val) async {
                            await ref.read(couponProvider.notifier).toggleStatus(coupon.code, val);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
