import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

class RouteMapEntity extends Equatable {
  final List<LatLng> coordinates;
  final double distance;
  final double duration;

  const RouteMapEntity({
    required this.coordinates,
    this.distance = 0.0,
    this.duration = 0.0,
  });

  @override
  List<Object?> get props => [coordinates, distance, duration];
}

