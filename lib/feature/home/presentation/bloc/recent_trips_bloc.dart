import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_recent_trips.dart';
import 'recent_trips_event.dart';
import 'recent_trips_state.dart';

class RecentTripsBloc extends Bloc<RecentTripsEvent, RecentTripsState> {
  final GetRecentTrips getRecentTrips;

  RecentTripsBloc({required this.getRecentTrips})
      : super(const RecentTripsInitial()) {
    on<FetchRecentTripsEvent>(_onFetchRecentTrips);
  }

  Future<void> _onFetchRecentTrips(
    FetchRecentTripsEvent event,
    Emitter<RecentTripsState> emit,
  ) async {
    emit(const RecentTripsLoading());

    final result = await getRecentTrips.getRecentTrips(limit: event.limit);

    result.fold(
      (failure) => emit(RecentTripsFailure(failure.message)),
      (trips) => emit(RecentTripsLoaded(trips)),
    );
  }
}
