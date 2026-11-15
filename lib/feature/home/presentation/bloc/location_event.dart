import 'package:equatable/equatable.dart';

sealed class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object?> get props => [];
}

class ResolveTripLocationsEvent extends LocationEvent {
  final String fromCity;
  final String toCity;

  const ResolveTripLocationsEvent({
    required this.fromCity,
    required this.toCity,
  });

  @override
  List<Object?> get props => [fromCity, toCity];
}

class ResetLocationsEvent extends LocationEvent {
  const ResetLocationsEvent();
}
