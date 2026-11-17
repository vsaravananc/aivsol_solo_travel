import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/route_map_entity.dart';
import '../../domain/repositories/route_map_repository.dart';
import '../datasources/route_map_remote_data_source.dart';

class RouteMapRepositoryImpl implements RouteMapRepository {
  final RouteMapRemoteDataSource remoteDataSource;

  RouteMapRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, RouteMapEntity>> getRouteMap({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
  }) async {
    final result = await remoteDataSource.getRouteMap(
      startLat: startLat,
      startLng: startLng,
      endLat: endLat,
      endLng: endLng,
    );
    return result.fold((failure) => Left(failure), (model) => Right(model));
  }
}
