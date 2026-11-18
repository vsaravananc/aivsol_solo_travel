import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../entities/place_search_entity.dart';
import '../repositories/map_picker_repository.dart';

class SearchPlacesUseCase {
  final MapPickerRepository repository;

  SearchPlacesUseCase(this.repository);

  Future<Either<Failure, List<PlaceSearchEntity>>> call(
    String query, {
    CancelToken? cancelToken,
  }) {
    return repository.searchPlaces(query, cancelToken: cancelToken);
  }
}
