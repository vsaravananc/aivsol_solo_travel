import 'package:equatable/equatable.dart';

sealed class HistoryEvent extends Equatable {
  const HistoryEvent();

  @override
  List<Object?> get props => [];
}

class FetchAllTripHistoryEvent extends HistoryEvent {
  const FetchAllTripHistoryEvent();
}
