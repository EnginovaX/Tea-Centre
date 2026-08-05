import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaymentMethod {
  final String id;
  final String label;
  final String icon;

  const PaymentMethod({
    required this.id,
    required this.label,
    required this.icon,
  });
}

class PaymentNotifier extends StateNotifier<List<PaymentMethod>> {
  PaymentNotifier() : super(const [
    PaymentMethod(id: 'cod', label: 'Cash on Delivery', icon: 'payments'),
    PaymentMethod(id: 'upi', label: 'UPI / GPay / Paytm', icon: 'account_balance_wallet'),
    PaymentMethod(id: 'razorpay', label: 'Credit / Debit Card', icon: 'credit_card'),
  ]);
}

final paymentProvider = StateNotifierProvider<PaymentNotifier, List<PaymentMethod>>((ref) {
  return PaymentNotifier();
});
