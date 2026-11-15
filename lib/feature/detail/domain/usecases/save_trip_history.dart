import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/enums/travel_style.dart';
import '../entities/budget_entity.dart';
import '../entities/weather_entity.dart';
import '../repositories/trip_history_repository.dart';
import '../../../home/domain/entities/location_entity.dart';

class SaveTripHistory {
  final TripHistoryRepository repository;

  const SaveTripHistory(this.repository);

 
  Future<Either<Failure, int>> saveTripHistory({
    required LocationEntity from,
    required LocationEntity to,
    required DateTime startDate,
    required DateTime endDate,
    required TravelStyle travelStyle,
    required BudgetEntity budget,
    WeatherEntity? weather,
  }) {
    return repository.saveTripHistory(
      from: from,
      to: to,
      startDate: startDate,
      endDate: endDate,
      travelStyle: travelStyle,
      budget: budget,
      weather: weather,
    );
  }
}
