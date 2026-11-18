import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../entities/place_search_entity.dart';
import '../entities/selected_location_entity.dart';

abstract class MapPickerRepository {
  Future<Either<Failure, List<PlaceSearchEntity>>> searchPlaces(
    String query, {
    CancelToken? cancelToken,
  });

  Future<Either<Failure, SelectedLocationEntity>> reverseGeocode({
    required double latitude,
    required double longitude,
  });
}
