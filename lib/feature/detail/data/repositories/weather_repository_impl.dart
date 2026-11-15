import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/weather_entity.dart';
import '../../domain/repositories/weather_repository.dart';
import '../datasources/weather_remote_data_source.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;

  WeatherRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, WeatherEntity>> getWeatherForecast({
    required double latitude,
    required double longitude,
    required DateTime fromDate,
    required DateTime toDate,
  }) async {
    try {
      final weatherModel = await remoteDataSource.getWeatherForecast(
        latitude: latitude,
        longitude: longitude,
        fromDate: fromDate,
        toDate: toDate,
      );
      return weatherModel;
    } catch (e) {
      return const Left(ServerFailure('Unexpected error occurred'));
    }
  }
}
