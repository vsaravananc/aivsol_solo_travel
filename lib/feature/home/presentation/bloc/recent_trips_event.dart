import 'package:equatable/equatable.dart';

sealed class RecentTripsEvent extends Equatable {
  const RecentTripsEvent();

  @override
  List<Object?> get props => [];
}

class FetchRecentTripsEvent extends RecentTripsEvent {
  final int limit;

  const FetchRecentTripsEvent({this.limit = 3});

  @override
  List<Object?> get props => [limit];
}
