import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/route_map_entity.dart';

abstract class RouteMapRepository {
  Future<Either<Failure, RouteMapEntity>> getRouteMap({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
  });
}

