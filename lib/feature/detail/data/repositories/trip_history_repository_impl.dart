import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/enums/travel_style.dart';
import '../../domain/entities/budget_entity.dart';
import '../../domain/entities/trip_history_entity.dart';
import '../../domain/entities/weather_entity.dart';
import '../../domain/repositories/trip_history_repository.dart';
import '../../../home/domain/entities/location_entity.dart';
import '../local/trip_history_local_data_source.dart';

class TripHistoryRepositoryImpl implements TripHistoryRepository {
  final TripHistoryLocalDataSource localDataSource;

  TripHistoryRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, int>> saveTripHistory({
    required LocationEntity from,
    required LocationEntity to,
    required DateTime startDate,
    required DateTime endDate,
    required TravelStyle travelStyle,
    required BudgetEntity budget,
    WeatherEntity? weather,
  }) async {
    try {
      final rowId = await localDataSource.saveTripHistory(
        from: from,
        to: to,
        startDate: startDate,
        endDate: endDate,
        travelStyle: travelStyle,
        budget: budget,
        weather: weather,
      );
      return Right(rowId);
    } catch (e) {
      return const Left(ServerFailure('Failed to save trip history locally.'));
    }
  }

  @override
  Future<Either<Failure, TripHistoryEntity?>> getTripHistoryById(int id) async {
    try {
      final trip = await localDataSource.getTripHistoryById(id);
      return Right(trip);
    } catch (e) {
      return const Left(DatabaseFailure('Failed to load trip history from local database.'));
    }
  }
}
