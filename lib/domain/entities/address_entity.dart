class AddressEntity {
  final String id;
  final String userId;
  final String label; // "Home", "Office", "Other"
  final String addressLine;
  final String city;
  final String pincode;
  final double? latitude;
  final double? longitude;
  final String? deliveryInstructions;
  final bool isDefault;

  const AddressEntity({
    required this.id,
    required this.userId,
    required this.label,
    required this.addressLine,
    required this.city,
    required this.pincode,
    this.latitude,
    this.longitude,
    this.deliveryInstructions,
    this.isDefault = false,
  });

  AddressEntity copyWith({
    String? id,
    String? userId,
    String? label,
    String? addressLine,
    String? city,
    String? pincode,
    double? latitude,
    double? longitude,
    String? deliveryInstructions,
    bool? isDefault,
  }) {
    return AddressEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      label: label ?? this.label,
      addressLine: addressLine ?? this.addressLine,
      city: city ?? this.city,
      pincode: pincode ?? this.pincode,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      deliveryInstructions: deliveryInstructions ?? this.deliveryInstructions,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}
