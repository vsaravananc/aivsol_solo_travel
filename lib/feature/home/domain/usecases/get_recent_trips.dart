import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../detail/domain/entities/trip_history_entity.dart';
import '../repositories/recent_trips_repository.dart';

class GetRecentTrips {
  final RecentTripsRepository repository;

  const GetRecentTrips(this.repository);

  Future<Either<Failure, List<TripHistoryEntity>>> getRecentTrips({int limit = 3}) {
    return repository.getRecentTrips(limit: limit);
  }
}
