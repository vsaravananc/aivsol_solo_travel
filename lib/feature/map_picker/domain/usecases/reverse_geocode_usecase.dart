import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/selected_location_entity.dart';
import '../repositories/map_picker_repository.dart';

class ReverseGeocodeUseCase {
  final MapPickerRepository repository;

  ReverseGeocodeUseCase(this.repository);

  Future<Either<Failure, SelectedLocationEntity>> call({
    required double latitude,
    required double longitude,
  }) {
    return repository.reverseGeocode(
      latitude: latitude,
      longitude: longitude,
    );
  }
}
