abstract class DeliveryRepository {
  Future<bool> checkDeliveryEligibility(double lat, double lng);
  Future<double> getCalculatedDistance(double lat, double lng);
}
