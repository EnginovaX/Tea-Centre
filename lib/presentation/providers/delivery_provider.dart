import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/delivery_repository.dart';
import 'dependency_providers.dart';

class DeliveryState {
  final bool isEligible;
  final double calculatedDistance;
  final bool isLoading;

  const DeliveryState({
    this.isEligible = true,
    this.calculatedDistance = 0.0,
    this.isLoading = false,
  });

  DeliveryState copyWith({
    bool? isEligible,
    double? calculatedDistance,
    bool? isLoading,
  }) {
    return DeliveryState(
      isEligible: isEligible ?? this.isEligible,
      calculatedDistance: calculatedDistance ?? this.calculatedDistance,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class DeliveryNotifier extends StateNotifier<DeliveryState> {
  final DeliveryRepository _repository;

  DeliveryNotifier(this._repository) : super(const DeliveryState());

  Future<void> validateAddressLocation(double lat, double lng) async {
    state = state.copyWith(isLoading: true);
    final eligible = await _repository.checkDeliveryEligibility(lat, lng);
    final distance = await _repository.getCalculatedDistance(lat, lng);
    state = DeliveryState(
      isEligible: eligible,
      calculatedDistance: distance,
      isLoading: false,
    );
  }
}

final deliveryProvider = StateNotifierProvider<DeliveryNotifier, DeliveryState>((ref) {
  final repo = ref.watch(deliveryRepositoryProvider);
  return DeliveryNotifier(repo);
});
