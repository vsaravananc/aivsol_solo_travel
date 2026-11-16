import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_all_trip_history.dart';
import 'history_event.dart';
import 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final GetAllTripHistory getAllTripHistory;

  HistoryBloc({required this.getAllTripHistory})
      : super(const HistoryInitial()) {
    on<FetchAllTripHistoryEvent>(_onFetchAllTripHistory);
  }

  Future<void> _onFetchAllTripHistory(
    FetchAllTripHistoryEvent event,
    Emitter<HistoryState> emit,
  ) async {
    emit(const HistoryLoading());

    final result = await getAllTripHistory.getAllTripHistory();

    result.fold(
      (failure) => emit(HistoryFailure(failure.message)),
      (trips) => emit(HistoryLoaded(trips)),
    );
  }
}
