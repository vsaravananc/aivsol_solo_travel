import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/route_map_entity.dart';
import '../repositories/route_map_repository.dart';

class GetRouteMapUseCase {
  final RouteMapRepository repository;

  GetRouteMapUseCase(this.repository);

  Future<Either<Failure, RouteMapEntity>> call({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
  }) {
    return repository.getRouteMap(
      startLat: startLat,
      startLng: startLng,
      endLat: endLat,
      endLng: endLng,
    );
  }
}
