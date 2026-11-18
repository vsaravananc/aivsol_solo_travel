import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/extensions/dio_extension.dart';
import '../models/place_search_model.dart';
import '../models/reverse_geocode_model.dart';

abstract class NominatimRemoteDataSource {
  Future<Either<Failure, List<PlaceSearchModel>>> searchPlaces(
    String query, {
    CancelToken? cancelToken,
  });

  Future<Either<Failure, ReverseGeocodeModel>> reverseGeocode({
    required double latitude,
    required double longitude,
  });
}

class NominatimRemoteDataSourceImpl implements NominatimRemoteDataSource {
  final Dio dio;

  static const String _searchUrl = 'https://nominatim.openstreetmap.org/search';
  static const String _reverseUrl = 'https://nominatim.openstreetmap.org/reverse';
  static const Map<String, String> _nominatimHeaders = {
    'User-Agent': 'AivsolSoloTravelApp/1.0.0 (https://github.com/aivsol; contact@aivsol.com)',
    'Accept': 'application/json',
  };

  final Map<String, List<PlaceSearchModel>> _searchCache = {};
  final Map<String, ReverseGeocodeModel> _reverseCache = {};

  DateTime _lastRequestTime = DateTime.fromMillisecondsSinceEpoch(0);

  NominatimRemoteDataSourceImpl({required this.dio});

  Future<void> _respectRateLimit() async {
    final now = DateTime.now();
    final elapsed = now.difference(_lastRequestTime);
    if (elapsed.inMilliseconds < 1000) {
      await Future.delayed(
        Duration(milliseconds: 1000 - elapsed.inMilliseconds),
      );
    }
    _lastRequestTime = DateTime.now();
  }

  @override
  Future<Either<Failure, List<PlaceSearchModel>>> searchPlaces(
    String query, {
    CancelToken? cancelToken,
  }) async {
    final cleanQuery = query.trim().toLowerCase();
    if (cleanQuery.isEmpty) {
      return const Right([]);
    }

    if (_searchCache.containsKey(cleanQuery)) {
      return Right(_searchCache[cleanQuery]!);
    }

    try {
      await _respectRateLimit();

      final response = await dio.get(
        _searchUrl,
        queryParameters: {
          'q': query.trim(),
          'format': 'jsonv2',
          'limit': 5,
          'addressdetails': 1,
        },
        options: Options(headers: _nominatimHeaders),
        cancelToken: cancelToken,
      );

      if (response.statusCode != 200) {
        return const Left(
          ServerFailure('Nominatim search failed. Please try again later.'),
        );
      }

      final dynamic data = response.data;
      if (data == null || data is! List) {
        return const Left(
          ParsingFailure('Unexpected place search response structure.'),
        );
      }

      final results = data
          .map((item) => PlaceSearchModel.fromJson(item as Map<String, dynamic>))
          .toList();

      _searchCache[cleanQuery] = results;
      return Right(results);
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        return const Right([]);
      }
      return Left(e.toFailure());
    } on FormatException catch (e) {
      return Left(FormateFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ReverseGeocodeModel>> reverseGeocode({
    required double latitude,
    required double longitude,
  }) async {
    final cacheKey =
        '${latitude.toStringAsFixed(5)},${longitude.toStringAsFixed(5)}';
    if (_reverseCache.containsKey(cacheKey)) {
      return Right(_reverseCache[cacheKey]!);
    }

    try {
      await _respectRateLimit();

      final response = await dio.get(
        _reverseUrl,
        queryParameters: {
          'format': 'jsonv2',
          'lat': latitude,
          'lon': longitude,
          'addressdetails': 1,
        },
        options: Options(headers: _nominatimHeaders),
      );

      if (response.statusCode != 200) {
        return const Left(
          ServerFailure('Reverse geocoding failed. Please try again later.'),
        );
      }

      final dynamic data = response.data;
      if (data == null || data is! Map<String, dynamic>) {
        return const Left(
          ParsingFailure('Unexpected reverse geocode response structure.'),
        );
      }

      if (data.containsKey('error')) {
        return const Left(
          LocationNotFoundFailure('Unable to find an address for this location.'),
        );
      }

      final model = ReverseGeocodeModel.fromJson(
        data,
        fallbackLatitude: latitude,
        fallbackLongitude: longitude,
      );

      _reverseCache[cacheKey] = model;
      return Right(model);
    } on DioException catch (e) {
      return Left(e.toFailure());
    } on FormatException catch (e) {
      return Left(FormateFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
