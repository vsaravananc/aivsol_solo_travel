import 'package:equatable/equatable.dart';

sealed class SaveTripHistoryState extends Equatable {
  const SaveTripHistoryState();

  @override
  List<Object?> get props => [];
}

/// Initial state — no insert has been attempted yet.
class TripHistoryNotSaved extends SaveTripHistoryState {
  const TripHistoryNotSaved();
}

/// The trip was successfully persisted. [savedId] is the auto-incremented
/// primary key of the new row.
class TripHistorySaved extends SaveTripHistoryState {
  final int savedId;

  const TripHistorySaved(this.savedId);

  @override
  List<Object?> get props => [savedId];
}

/// The insert was attempted but failed. [errorMessage] describes the cause.
class TripHistorySaveFailed extends SaveTripHistoryState {
  final String errorMessage;

  const TripHistorySaveFailed(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
