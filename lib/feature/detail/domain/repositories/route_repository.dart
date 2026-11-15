import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/route_entity.dart';

abstract class RouteRepository {
  Future<Either<Failure, RouteEntity>> getRoundTripDistance({
    required double fromLatitude,
    required double fromLongitude,
    required double toLatitude,
    required double toLongitude,
  });
}
