import 'package:aivsol_solo_travel/core/error/failures.dart';
import 'package:aivsol_solo_travel/core/extensions/dio_extension.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../models/weather_model.dart';

abstract class WeatherRemoteDataSource {
  Future<Either<Failure, WeatherModel>> getWeatherForecast({
    required double latitude,
    required double longitude,
    required DateTime fromDate,
    required DateTime toDate,
  });
}

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final Dio dio;

  WeatherRemoteDataSourceImpl({required this.dio});

  static const String _endpoint = 'https://api.open-meteo.com/v1/forecast';

  @override
  Future<Either<Failure, WeatherModel>> getWeatherForecast({
    required double latitude,
    required double longitude,
    required DateTime fromDate,
    required DateTime toDate,
  }) async {
    final formattedFromDate =
        '${fromDate.year}-${fromDate.month.toString().padLeft(2, '0')}-${fromDate.day.toString().padLeft(2, '0')}';
    final formattedEndDate =
        '${toDate.year}-${toDate.month.toString().padLeft(2, '0')}-${toDate.day.toString().padLeft(2, '0')}';

    try {
      final response = await dio.get(
        _endpoint,
        queryParameters: {
          'latitude': latitude,
          'longitude': longitude,
          'current': 'temperature_2m,relative_humidity_2m,weather_code',
          'daily': 'weather_code,temperature_2m_max,temperature_2m_min',
          'timezone': 'Asia/Kolkata',
          'start_date': formattedFromDate,
          'end_date': formattedEndDate,
        },
      );

      if (response.statusCode != 200) {
        return const Left(
          ServerFailure('open-meteo server error. Please try again later.'),
        );
      }

      final dynamic data = response.data;
      if (data == null || data is! Map<String, dynamic>) {
        return const Left(
          ParsingFailure('Unexpected routing API response structure.'),
        );
      }
      return Right(WeatherModel.fromJson(data));
    } on DioException catch (e) {
      return Left(e.toFailure());
    } on FormatException {
      return const Left(FormateFailure('Failed to parse routing API response'));
    } catch (e) {
      return const Left(ServerFailure());
    }
  }
}
