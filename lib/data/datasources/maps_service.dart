import 'dart:math';

class MapsService {
  // Central location coordinate for Tea Centre (e.g., Churchgate Mumbai)
  static const double storeLatitude = 18.9322;
  static const double storeLongitude = 72.8264;
  static const double maxDeliveryRadiusKm = 10.0;

  /// Calculates the distance in kilometers between two points using the Haversine formula
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371.0; // Earth's radius in kilometers

    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLon = _degreesToRadians(lon2 - lon1);

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  /// Verifies if a user's address location is eligible for store delivery
  bool isWithinDeliveryRadius(double userLat, double userLng) {
    final distance = calculateDistance(storeLatitude, storeLongitude, userLat, userLng);
    return distance <= maxDeliveryRadiusKm;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }
}
