import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../detail/data/local/trip_history_local_data_source.dart';
import '../../../detail/domain/entities/trip_history_entity.dart';
import '../../domain/repositories/recent_trips_repository.dart';

class RecentTripsRepositoryImpl implements RecentTripsRepository {
  final TripHistoryLocalDataSource localDataSource;

  RecentTripsRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<TripHistoryEntity>>> getRecentTrips({
    int limit = 3,
  }) async {
    try {
      final trips = await localDataSource.getRecentTripHistory(limit: limit);
      return Right(trips);
    } catch (e) {
      return const Left(DatabaseFailure('Failed to load recent trips.'));
    }
  }
}
