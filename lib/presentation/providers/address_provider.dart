import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/address_entity.dart';
import 'dependency_providers.dart';

class AddressNotifier extends StateNotifier<AsyncValue<List<AddressEntity>>> {
  final Ref _ref;

  AddressNotifier(this._ref) : super(const AsyncValue.loading());

  Future<void> fetchAddresses(String userId) async {
    state = const AsyncValue.loading();
    try {
      final list = await _ref.read(addressRepositoryProvider).getAddresses(userId);
      state = AsyncValue.data(list);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> saveAddress(AddressEntity address) async {
    try {
      await _ref.read(addressRepositoryProvider).saveAddress(address);
      await fetchAddresses(address.userId);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteAddress(String userId, String addressId) async {
    try {
      await _ref.read(addressRepositoryProvider).deleteAddress(addressId);
      await fetchAddresses(userId);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> setDefaultAddress(String userId, String addressId) async {
    try {
      await _ref.read(addressRepositoryProvider).setDefaultAddress(userId, addressId);
      await fetchAddresses(userId);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final addressProvider = StateNotifierProvider<AddressNotifier, AsyncValue<List<AddressEntity>>>((ref) {
  return AddressNotifier(ref);
});
