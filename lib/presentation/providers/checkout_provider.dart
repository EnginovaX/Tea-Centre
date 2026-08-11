import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/address_entity.dart';

class CheckoutState {
  final bool isDelivery; // true = Home Delivery, false = Self Pickup
  final AddressEntity? selectedAddress;
  final String deliveryInstructions;
  final String notes;

  const CheckoutState({
    this.isDelivery = true,
    this.selectedAddress,
    this.deliveryInstructions = '',
    this.notes = '',
  });

  CheckoutState copyWith({
    bool? isDelivery,
    AddressEntity? selectedAddress,
    String? deliveryInstructions,
    String? notes,
  }) {
    return CheckoutState(
      isDelivery: isDelivery ?? this.isDelivery,
      selectedAddress: selectedAddress ?? this.selectedAddress,
      deliveryInstructions: deliveryInstructions ?? this.deliveryInstructions,
      notes: notes ?? this.notes,
    );
  }
}

class CheckoutNotifier extends StateNotifier<CheckoutState> {
  CheckoutNotifier() : super(const CheckoutState());

  void setFulfillmentType({required bool isDelivery}) {
    state = state.copyWith(isDelivery: isDelivery);
  }

  void selectAddress(AddressEntity address) {
    state = state.copyWith(selectedAddress: address);
  }

  void updateDeliveryInstructions(String inst) {
    state = state.copyWith(deliveryInstructions: inst);
  }

  void updateNotes(String n) {
    state = state.copyWith(notes: n);
  }
}

final checkoutProvider = StateNotifierProvider<CheckoutNotifier, CheckoutState>((ref) {
  return CheckoutNotifier();
});
