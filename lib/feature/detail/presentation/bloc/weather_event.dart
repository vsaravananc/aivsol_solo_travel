import 'package:equatable/equatable.dart';

import '../../../home/domain/entities/location_entity.dart';

sealed class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object?> get props => [];
}

class FetchWeatherEvent extends WeatherEvent {
  final LocationEntity destinationLocation;
  final DateTime startDate;
  final DateTime endDate;

  const FetchWeatherEvent({
    required this.destinationLocation,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [destinationLocation, startDate, endDate];
}
