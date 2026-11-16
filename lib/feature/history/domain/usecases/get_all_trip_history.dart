import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../detail/domain/entities/trip_history_entity.dart';
import '../repositories/history_repository.dart';

class GetAllTripHistory {
  final HistoryRepository repository;

  const GetAllTripHistory(this.repository);

  Future<Either<Failure, List<TripHistoryEntity>>> getAllTripHistory() {
    return repository.getAllTripHistory();
  }
}
