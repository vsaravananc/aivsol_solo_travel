import 'package:equatable/equatable.dart';

import '../../../detail/domain/entities/trip_history_entity.dart';

sealed class RecentTripsState extends Equatable {
  const RecentTripsState();

  @override
  List<Object?> get props => [];
}

class RecentTripsInitial extends RecentTripsState {
  const RecentTripsInitial();
}

class RecentTripsLoading extends RecentTripsState {
  const RecentTripsLoading();
}

class RecentTripsLoaded extends RecentTripsState {
  final List<TripHistoryEntity> trips;

  const RecentTripsLoaded(this.trips);

  @override
  List<Object?> get props => [trips];
}

class RecentTripsFailure extends RecentTripsState {
  final String errorMessage;

  const RecentTripsFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
