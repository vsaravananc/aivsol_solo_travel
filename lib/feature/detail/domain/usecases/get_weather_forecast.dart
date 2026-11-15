import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/weather_entity.dart';
import '../repositories/weather_repository.dart';

class GetWeatherForecast {
  final WeatherRepository repository;

  const GetWeatherForecast(this.repository);

  Future<Either<Failure, WeatherEntity>> getWeatherForecast({
    required double latitude,
    required double longitude,
    required DateTime fromDate,
    required DateTime toDate,
  }) async {
    return await repository.getWeatherForecast(
      latitude: latitude,
      longitude: longitude,
      fromDate: fromDate,
      toDate: toDate,
    );
  }
}
