import 'package:aivsol_solo_travel/core/error/failures.dart';
import 'package:aivsol_solo_travel/core/extensions/dio_extension.dart';
import 'package:aivsol_solo_travel/core/utility/api_end_points.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../models/location_model.dart';

abstract class TripGeocodingRemoteDataSource {
  Future<Either<Failure, LocationModel>> getLocationCoordinates(
    String cityName,
  );
}

class TripGeocodingRemoteDataSourceImpl
    implements TripGeocodingRemoteDataSource {
  final Dio dio;

  TripGeocodingRemoteDataSourceImpl({required this.dio});

  @override
  Future<Either<Failure, LocationModel>> getLocationCoordinates(
    String cityName,
  ) async {
    final sanitizedCity = _sanitizeCityName(cityName);
    try {
      final response = await dio.get(
        ApiEndPoints.openMeteoGeoCoding,
        queryParameters: {
          'name': sanitizedCity,
          'count': 1,
          'language': 'en',
          'format': 'json',
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

      final results = data['results'];
      if (results == null || results is! List || results.isEmpty) {
        return Left(
          LocationNotFoundFailure('No location found for "$cityName".'),
        );
      }

      final firstResult = results.first;
      if (firstResult is! Map<String, dynamic>) {
        return const Left(
          ParsingFailure('Unexpected routing API response structure.'),
        );
      }
      return Right(LocationModel.fromJson(firstResult));
    } on DioException catch (e) {
      return Left(e.toFailure());
    } on FormatException {
      return const Left(FormateFailure('Failed to parse routing API response'));
    } catch (e) {
      throw ParsingException('Failed to process location data: $e');
    }
  }

  String _sanitizeCityName(String rawCity) {
    final cleaned = rawCity.split('(').first.split(',').first.trim();
    return cleaned.isNotEmpty ? cleaned : rawCity.trim();
  }
}
