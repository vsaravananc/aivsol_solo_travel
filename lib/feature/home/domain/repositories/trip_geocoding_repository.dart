import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/location_entity.dart';

abstract class TripGeocodingRepository {
  Future<Either<Failure, LocationEntity>> getLocationCoordinates(String cityName);
}
