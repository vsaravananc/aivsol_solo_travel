import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/enums/travel_style.dart';
import '../entities/budget_entity.dart';
import '../entities/weather_entity.dart';
import '../../../home/domain/entities/location_entity.dart';

abstract class TripHistoryRepository {
  
  Future<Either<Failure, int>> saveTripHistory({
    required LocationEntity from,
    required LocationEntity to,
    required DateTime startDate,
    required DateTime endDate,
    required TravelStyle travelStyle,
    required BudgetEntity budget,
    WeatherEntity? weather,
  });
}
