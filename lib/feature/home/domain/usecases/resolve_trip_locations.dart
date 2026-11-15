import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/location_entity.dart';

typedef TripLocations = ({LocationEntity fromLocation, LocationEntity toLocation});

class ResolveTripLocations {
  const ResolveTripLocations();


  Either<Failure, TripLocations> resolveResults(
    List<Either<Failure, LocationEntity>> results,
  ) {
    final fromResult = results[0];
    final toResult = results[1];

    LocationEntity? fromLocation;
    LocationEntity? toLocation;

    fromResult.fold((_) {}, (s) => fromLocation = s);
    toResult.fold((_) {}, (s) => toLocation = s);

    if (fromLocation == null && toLocation == null) {
      return const Left(
        ServerFailure('Failed to resolve coordinates for both cities'),
      );
    } else if (fromLocation == null) {
      return const Left(
        ServerFailure('Failed to resolve coordinates for from city'),
      );
    } else if (toLocation == null) {
      return const Left(
        ServerFailure('Failed to resolve coordinates for to city'),
      );
    }

    return Right((
      fromLocation: fromLocation!,
      toLocation: toLocation!,
    ));
  }

}
