import '../../domain/entities/selected_location_entity.dart';

class ReverseGeocodeModel extends SelectedLocationEntity {
  const ReverseGeocodeModel({
    required super.address,
    required super.latitude,
    required super.longitude,
  });

  factory ReverseGeocodeModel.fromJson(
    Map<String, dynamic> json, {
    required double fallbackLatitude,
    required double fallbackLongitude,
  }) {
    final displayName = json['display_name'] as String?;
    if (displayName == null || displayName.trim().isEmpty) {
      throw const FormatException('No readable address found in response.');
    }

    final latStr = json['lat']?.toString();
    final lonStr = json['lon']?.toString();
    final lat = latStr != null ? double.tryParse(latStr) ?? fallbackLatitude : fallbackLatitude;
    final lon = lonStr != null ? double.tryParse(lonStr) ?? fallbackLongitude : fallbackLongitude;

    return ReverseGeocodeModel(
      address: displayName.trim(),
      latitude: lat,
      longitude: lon,
    );
  }
}
