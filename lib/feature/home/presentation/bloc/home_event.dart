import 'package:aivsol_solo_travel/core/enums/travel_style.dart';
import 'package:equatable/equatable.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class FromLocationChangedEvent extends HomeEvent {
  final String from;

  const FromLocationChangedEvent(this.from);

  @override
  List<Object?> get props => [from];
}

class ToLocationChangedEvent extends HomeEvent {
  final String to;

  const ToLocationChangedEvent(this.to);

  @override
  List<Object?> get props => [to];
}

class LocationsSwappedEvent extends HomeEvent {
  const LocationsSwappedEvent();
}

class DateRangeChangedEvent extends HomeEvent {
  final DateTime startDate;
  final DateTime endDate;

  const DateRangeChangedEvent({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [startDate, endDate];
}

class TravelStyleChangedEvent extends HomeEvent {
  final TravelStyle travelStyle;

  const TravelStyleChangedEvent(this.travelStyle);

  @override
  List<Object?> get props => [travelStyle];
}
