import '../../domain/entities/place_search_entity.dart';

class PlaceSearchModel extends PlaceSearchEntity {
  const PlaceSearchModel({
    required super.name,
    required super.displayName,
    required super.latitude,
    required super.longitude,
  });

  factory PlaceSearchModel.fromJson(Map<String, dynamic> json) {
    final name = json['name'] as String? ?? '';
    final rawDisplayName = json['display_name'] as String? ?? '';
    final latStr = json['lat']?.toString() ?? '0.0';
    final lonStr = json['lon']?.toString() ?? '0.0';
    final lat = double.tryParse(latStr) ?? 0.0;
    final lon = double.tryParse(lonStr) ?? 0.0;

    final city = _extractCity(
      json,
      rawDisplayName: rawDisplayName,
      name: name,
    );

    final resolvedName = name.trim().isNotEmpty
        ? name.trim()
        : (rawDisplayName.contains(',')
            ? rawDisplayName.split(',').first.trim()
            : (city.isNotEmpty ? city : 'Location'));

    return PlaceSearchModel(
      name: resolvedName.isNotEmpty ? resolvedName : 'Location',
      displayName: city,
      latitude: lat,
      longitude: lon,
    );
  }

  static String _extractCity(
    Map<String, dynamic> json, {
    required String rawDisplayName,
    required String name,
  }) {
    // 1. Try to extract city from Nominatim addressdetails if available
    final address = json['address'];
    if (address is Map<String, dynamic>) {
      final cityCandidate = address['city'] ??
          address['town'] ??
          address['village'] ??
          address['municipality'] ??
          address['hamlet'] ??
          address['city_district'] ??
          address['district'] ??
          address['county'] ??
          address['state_district'] ??
          address['state'];
      if (cityCandidate != null && cityCandidate.toString().trim().isNotEmpty) {
        return cityCandidate.toString().trim();
      }
    }

    // 2. Fallback: Extract city from display_name avoiding full address
    if (rawDisplayName.contains(',')) {
      final parts = rawDisplayName
          .split(',')
          .map((p) => p.trim())
          .where((p) => p.isNotEmpty)
          .toList();

      if (name.trim().isNotEmpty &&
          parts.first.toLowerCase() == name.trim().toLowerCase()) {
        return parts.first;
      } else if (parts.length > 2) {
        return parts[1];
      } else if (parts.isNotEmpty) {
        return parts.first;
      }
    }

    if (name.trim().isNotEmpty) {
      return name.trim();
    }

    if (rawDisplayName.trim().isNotEmpty) {
      return rawDisplayName.trim();
    }

    return 'Location';
  }
}
