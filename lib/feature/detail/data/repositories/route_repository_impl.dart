import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/route_entity.dart';
import '../../domain/repositories/route_repository.dart';
import '../datasources/route_remote_data_source.dart';

class RouteRepositoryImpl implements RouteRepository {
  final RouteRemoteDataSource remoteDataSource;
  RouteRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, RouteEntity>> getRoundTripDistance({
    required double fromLatitude,
    required double fromLongitude,
    required double toLatitude,
    required double toLongitude,
  }) async {
    try {
      final routeModel = await remoteDataSource.getRoundTripDistance(
        fromLatitude: fromLatitude,
        fromLongitude: fromLongitude,
        toLatitude: toLatitude,
        toLongitude: toLongitude,
      );
      return routeModel;
    } catch (e) {
      return const Left(ServerFailure('Unexpected routing error occurred'));
    }
  }
}
