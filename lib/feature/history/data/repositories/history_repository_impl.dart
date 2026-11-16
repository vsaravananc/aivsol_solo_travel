import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../detail/data/local/trip_history_local_data_source.dart';
import '../../../detail/domain/entities/trip_history_entity.dart';
import '../../domain/repositories/history_repository.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final TripHistoryLocalDataSource localDataSource;

  HistoryRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<TripHistoryEntity>>> getAllTripHistory() async {
    try {
      final trips = await localDataSource.getAllTripHistory();
      return Right(trips);
    } catch (e) {
      return const Left(DatabaseFailure('Failed to load trip history.'));
    }
  }
}
