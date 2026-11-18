import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/place_search_entity.dart';
import '../../domain/entities/selected_location_entity.dart';
import '../../domain/repositories/map_picker_repository.dart';
import '../datasources/nominatim_remote_data_source.dart';

class MapPickerRepositoryImpl implements MapPickerRepository {
  final NominatimRemoteDataSource remoteDataSource;

  MapPickerRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<PlaceSearchEntity>>> searchPlaces(
    String query, {
    CancelToken? cancelToken,
  }) async {
    final result = await remoteDataSource.searchPlaces(
      query,
      cancelToken: cancelToken,
    );
    return result.fold(
      (failure) => Left(failure),
      (models) => Right(models),
    );
  }

  @override
  Future<Either<Failure, SelectedLocationEntity>> reverseGeocode({
    required double latitude,
    required double longitude,
  }) async {
    final result = await remoteDataSource.reverseGeocode(
      latitude: latitude,
      longitude: longitude,
    );
    return result.fold(
      (failure) => Left(failure),
      (model) => Right(model),
    );
  }
}
