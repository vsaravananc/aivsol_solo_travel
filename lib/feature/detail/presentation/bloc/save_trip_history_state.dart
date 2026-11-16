import 'package:equatable/equatable.dart';

sealed class SaveTripHistoryState extends Equatable {
  const SaveTripHistoryState();

  @override
  List<Object?> get props => [];
}

class TripHistoryNotSaved extends SaveTripHistoryState {
  const TripHistoryNotSaved();
}

class TripHistorySaved extends SaveTripHistoryState {
  final int savedId;

  const TripHistorySaved(this.savedId);

  @override
  List<Object?> get props => [savedId];
}

class TripHistorySaveFailed extends SaveTripHistoryState {
  final String errorMessage;

  const TripHistorySaveFailed(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
