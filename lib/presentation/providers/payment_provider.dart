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

// Razorpay secure payment state
class RazorpayState {
  final bool isLoading;
  final String? errorMessage;
  final bool isVerified;
  final String? paymentId;

  const RazorpayState({
    this.isLoading = false,
    this.errorMessage,
    this.isVerified = false,
    this.paymentId,
  });

  RazorpayState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isVerified,
    String? paymentId,
  }) {
    return RazorpayState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isVerified: isVerified ?? this.isVerified,
      paymentId: paymentId ?? this.paymentId,
    );
  }
}

class RazorpayPaymentNotifier extends StateNotifier<RazorpayState> {
  RazorpayPaymentNotifier() : super(const RazorpayState());

  /// Creates a mock Razorpay order ID from the simulated backend
  Future<String> createRazorpayOrder(double amount) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    await Future.delayed(const Duration(milliseconds: 600)); // Simulating network latency
    final mockOrderId = "order_${DateTime.now().millisecondsSinceEpoch}";
    state = state.copyWith(isLoading: false);
    return mockOrderId;
  }

  /// Verifies the signature securely with backend verification logics
  Future<bool> verifyPaymentSignature({
    required String orderId,
    required String paymentId,
    required String signature,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    await Future.delayed(const Duration(milliseconds: 800)); // Simulating backend validation

    // Simulated HMAC-SHA256 verification validation
    // In production, the backend generates HMAC-SHA256 using the orderId + "|" + paymentId and secret key,
    // then compares with the signature.
    final bool isValid = signature.isNotEmpty && signature.startsWith("sig_");

    if (isValid) {
      state = state.copyWith(
        isLoading: false,
        isVerified: true,
        paymentId: paymentId,
      );
      return true;
    } else {
      state = state.copyWith(
        isLoading: false,
        isVerified: false,
        errorMessage: "Payment signature mismatch. Transaction untrusted.",
      );
      return false;
    }
  }

  void reset() {
    state = const RazorpayState();
  }
}

final razorpayPaymentProvider = StateNotifierProvider<RazorpayPaymentNotifier, RazorpayState>((ref) {
  return RazorpayPaymentNotifier();
});
