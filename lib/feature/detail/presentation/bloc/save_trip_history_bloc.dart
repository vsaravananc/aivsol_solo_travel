import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/save_trip_history.dart';
import 'save_trip_history_event.dart';
import 'save_trip_history_state.dart';

class SaveTripHistoryBloc
    extends Bloc<SaveTripHistoryEvent, SaveTripHistoryState> {
  final SaveTripHistory saveTripHistory;

  SaveTripHistoryBloc({required this.saveTripHistory})
    : super(const TripHistoryNotSaved()) {
    on<SaveTripHistoryRequested>(_onSaveTripHistoryRequested);
    on<RestartSaveTripHistoryEvent>(_onRestartSaveTripHistoryEvent);
  }

  @override
  void onTransition(
    Transition<SaveTripHistoryEvent, SaveTripHistoryState> transition,
  ) {
    print('-' * 40);
    print(transition.toString().replaceAll(',', '\n'));
    print('-' * 40);
    super.onTransition(transition);
  }

  Future<void> _onSaveTripHistoryRequested(
    SaveTripHistoryRequested event,
    Emitter<SaveTripHistoryState> emit,
  ) async {
    final result = await saveTripHistory.saveTripHistory(
      from: event.from,
      to: event.to,
      startDate: event.startDate,
      endDate: event.endDate,
      travelStyle: event.travelStyle,
      budget: event.budget,
      weather: event.weather,
    );

    result.fold(
      (failure) => emit(TripHistorySaveFailed(failure.message)),
      (rowId) => emit(TripHistorySaved(rowId)),
    );
  }

  Future<void> _onRestartSaveTripHistoryEvent(
    RestartSaveTripHistoryEvent event,
    Emitter<SaveTripHistoryState> emit,
  ) async {
    emit(const TripHistoryNotSaved());
  }
}
