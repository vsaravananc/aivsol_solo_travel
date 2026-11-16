import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../detail/domain/entities/trip_history_entity.dart';

abstract class HistoryRepository {
  Future<Either<Failure, List<TripHistoryEntity>>> getAllTripHistory();
}
