import '../../domain/repositories/delivery_repository.dart';
import '../datasources/maps_service.dart';

class DeliveryRepositoryImpl implements DeliveryRepository {
  final MapsService _mapsService;

  DeliveryRepositoryImpl({required MapsService mapsService})
      : _mapsService = mapsService;

  @override
  Future<bool> checkDeliveryEligibility(double lat, double lng) async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _mapsService.isWithinDeliveryRadius(lat, lng);
  }

  @override
  Future<double> getCalculatedDistance(double lat, double lng) async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _mapsService.calculateDistance(
      MapsService.storeLatitude,
      MapsService.storeLongitude,
      lat,
      lng,
    );
  }
}
