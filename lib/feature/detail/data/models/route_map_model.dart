import 'package:latlong2/latlong.dart';

import '../../domain/entities/route_map_entity.dart';

class RouteMapModel extends RouteMapEntity {
  const RouteMapModel({
    required super.coordinates,
    super.distance,
    super.duration,
  });

  factory RouteMapModel.fromJson(Map<String, dynamic> json) {
    final code = json['code'] as String?;
    if (code != 'Ok') {
      throw FormatException('OSRM returned non-OK response: $code');
    }

    final routes = json['routes'] as List?;
    if (routes == null || routes.isEmpty) {
      throw const FormatException('No routes found in OSRM response');
    }

    final firstRoute = routes.first as Map<String, dynamic>;
    final geometry = firstRoute['geometry'] as Map<String, dynamic>?;
    if (geometry == null) {
      throw const FormatException('Missing geometry in OSRM response');
    }

    final rawCoordinates = geometry['coordinates'] as List?;
    if (rawCoordinates == null || rawCoordinates.isEmpty) {
      throw const FormatException('Route coordinates are empty');
    }

    final List<LatLng> latLngList = [];
    for (final item in rawCoordinates) {
      if (item is List && item.length >= 2) {
        final lng = (item[0] as num).toDouble();
        final lat = (item[1] as num).toDouble();
        latLngList.add(LatLng(lat, lng));
      }
    }

    if (latLngList.isEmpty) {
      throw const FormatException('Failed to parse route coordinates');
    }

    final distance = (firstRoute['distance'] as num?)?.toDouble() ?? 0.0;
    final duration = (firstRoute['duration'] as num?)?.toDouble() ?? 0.0;

    return RouteMapModel(
      coordinates: latLngList,
      distance: distance,
      duration: duration,
    );
  }
}
