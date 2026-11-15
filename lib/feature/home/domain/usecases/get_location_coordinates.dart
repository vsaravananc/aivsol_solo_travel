import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/location_entity.dart';
import '../repositories/trip_geocoding_repository.dart';

class GetLocationCoordinates {
  final TripGeocodingRepository repository;

  const GetLocationCoordinates(this.repository);

  Future<Either<Failure, LocationEntity>> getLocationCoordinates(String cityName) async {
    return await repository.getLocationCoordinates(cityName);
  }
}
