import '../../../../core/error/exceptions.dart';
import '../../domain/entities/route_entity.dart';

class RouteModel extends RouteEntity {
  const RouteModel({required super.rawdistance});

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    final routes = json['routes'];

    if (routes == null || routes is! List || routes.isEmpty) {
      throw const ParsingException(
        'No driving routes found between locations.',
      );
    }

    final firstRoute = routes.first;
    if (firstRoute is! Map<String, dynamic>) {
      throw const ParsingException(
        'Invalid route structure in routing response.',
      );
    }

    final distanceMeters = firstRoute['distance'];
    if (distanceMeters == null || distanceMeters is! num) {
      throw const ParsingException(
        'Missing or invalid distance in route data.',
      );
    }

    return RouteModel(rawdistance: firstRoute['distance']);
  }
}
