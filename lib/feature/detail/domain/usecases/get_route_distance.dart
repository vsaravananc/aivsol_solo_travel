import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/route_entity.dart';
import '../repositories/route_repository.dart';

class GetRouteDistance {
  final RouteRepository repository;
  const GetRouteDistance(this.repository);
  Future<Either<Failure, RouteEntity>> getRoundTripDistance({
    required double fromLatitude,
    required double fromLongitude,
    required double toLatitude,
    required double toLongitude,
  }) async {
    return await repository.getRoundTripDistance(
      fromLatitude: fromLatitude,
      fromLongitude: fromLongitude,
      toLatitude: toLatitude,
      toLongitude: toLongitude,
    );
  }
}
