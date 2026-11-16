import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/trip_history_entity.dart';
import '../repositories/trip_history_repository.dart';

class GetTripHistoryById {
  final TripHistoryRepository repository;

  const GetTripHistoryById(this.repository);

  Future<Either<Failure, TripHistoryEntity?>> call(int id) {
    return repository.getTripHistoryById(id);
  }
}
