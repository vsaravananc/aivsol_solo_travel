import 'package:equatable/equatable.dart';

sealed class RouteMapEvent extends Equatable {
  const RouteMapEvent();

  @override
  List<Object?> get props => [];
}

class FetchRouteMapEvent extends RouteMapEvent {
  final double startLat;
  final double startLng;
  final double endLat;
  final double endLng;

  const FetchRouteMapEvent({
    required this.startLat,
    required this.startLng,
    required this.endLat,
    required this.endLng,
  });

  @override
  List<Object?> get props => [startLat, startLng, endLat, endLng];
}
