import 'package:equatable/equatable.dart';

import '../../domain/entities/location_entity.dart';

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

class SetPredefinedLocationsEvent extends LocationEvent {
  final LocationEntity fromLocation;
  final LocationEntity toLocation;

  const SetPredefinedLocationsEvent({
    required this.fromLocation,
    required this.toLocation,
  });

  @override
  List<Object?> get props => [fromLocation, toLocation];
}
