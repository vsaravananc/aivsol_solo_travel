import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/weather_entity.dart';

abstract class WeatherRepository {
  Future<Either<Failure, WeatherEntity>> getWeatherForecast({
    required double latitude,
    required double longitude,
    required DateTime fromDate,
    required DateTime toDate,
  });
}
