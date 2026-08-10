import '../../domain/entities/address_entity.dart';
import '../../domain/repositories/address_repository.dart';
import '../datasources/firestore_service.dart';
import '../datasources/session_manager.dart';

class AddressRepositoryImpl implements AddressRepository {
  final FirestoreService _firestoreService;
  final SessionManager _sessionManager;

  AddressRepositoryImpl({
    required FirestoreService firestoreService,
    required SessionManager sessionManager,
  })  : _firestoreService = firestoreService,
        _sessionManager = sessionManager;

  @override
  Future<List<AddressEntity>> getAddresses(String userId) async {
    final cached = _sessionManager.getCachedAddresses();
    if (cached != null) {
      return cached.map(_mapToEntity).toList();
    }

    try {
      final list = await _firestoreService.getAddresses(userId);
      await _sessionManager.cacheAddresses(list);
      return list.map(_mapToEntity).toList();
    } catch (_) {
      if (cached != null) {
        return cached.map(_mapToEntity).toList();
      }
      return [];
    }
  }

  @override
  Future<void> saveAddress(AddressEntity address) async {
    final raw = _mapToMap(address);
    await _firestoreService.saveAddress(address.id, raw);

    final cachedList = _sessionManager.getCachedAddresses() ?? [];
    cachedList.removeWhere((item) => item['id'] == address.id);
    cachedList.add(raw);
    await _sessionManager.cacheAddresses(cachedList);
  }

  @override
  Future<void> deleteAddress(String addressId) async {
    await _firestoreService.deleteAddress(addressId);

    final cachedList = _sessionManager.getCachedAddresses() ?? [];
    cachedList.removeWhere((item) => item['id'] == addressId);
    await _sessionManager.cacheAddresses(cachedList);
  }

  @override
  Future<void> setDefaultAddress(String userId, String addressId) async {
    final list = await getAddresses(userId);
    final updatedList = <Map<String, dynamic>>[];

    for (var addr in list) {
      final isDef = addr.id == addressId;
      final updatedAddr = addr.copyWith(isDefault: isDef);
      final raw = _mapToMap(updatedAddr);
      updatedList.add(raw);
      await _firestoreService.saveAddress(addr.id, raw);
    }
    await _sessionManager.cacheAddresses(updatedList);
  }

  AddressEntity _mapToEntity(Map<String, dynamic> data) {
    return AddressEntity(
      id: data['id'] as String,
      userId: data['userId'] as String,
      label: data['label'] as String? ?? 'Home',
      addressLine: data['addressLine'] as String? ?? '',
      city: data['city'] as String? ?? '',
      pincode: data['pincode'] as String? ?? '',
      latitude: data['latitude'] as double?,
      longitude: data['longitude'] as double?,
      deliveryInstructions: data['deliveryInstructions'] as String?,
      isDefault: data['isDefault'] as bool? ?? false,
    );
  }

  Map<String, dynamic> _mapToMap(AddressEntity address) {
    return {
      'id': address.id,
      'userId': address.userId,
      'label': address.label,
      'addressLine': address.addressLine,
      'city': address.city,
      'pincode': address.pincode,
      'latitude': address.latitude,
      'longitude': address.longitude,
      'deliveryInstructions': address.deliveryInstructions,
      'isDefault': address.isDefault,
    };
  }
}
