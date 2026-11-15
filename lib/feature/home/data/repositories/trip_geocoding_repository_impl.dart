import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/location_entity.dart';
import '../../domain/repositories/trip_geocoding_repository.dart';
import '../datasources/trip_geocoding_remote_data_source.dart';

class TripGeocodingRepositoryImpl implements TripGeocodingRepository {
  final TripGeocodingRemoteDataSource remoteDataSource;

  TripGeocodingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, LocationEntity>> getLocationCoordinates(
    String cityName,
  ) async {
    try {
      final locationModel = await remoteDataSource.getLocationCoordinates(
        cityName,
      );
      return locationModel;
    } on LocationNotFoundException catch (e) {
      return Left(LocationNotFoundFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred: $e'));
    }
  }
}
