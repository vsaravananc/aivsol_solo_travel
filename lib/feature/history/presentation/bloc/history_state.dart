import 'package:equatable/equatable.dart';

import '../../../detail/domain/entities/trip_history_entity.dart';

sealed class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object?> get props => [];
}

class HistoryInitial extends HistoryState {
  const HistoryInitial();
}

class HistoryLoading extends HistoryState {
  const HistoryLoading();
}

class HistoryLoaded extends HistoryState {
  final List<TripHistoryEntity> trips;

  const HistoryLoaded(this.trips);

  @override
  List<Object?> get props => [trips];
}

class HistoryFailure extends HistoryState {
  final String errorMessage;

  const HistoryFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
