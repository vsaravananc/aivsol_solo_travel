import 'package:equatable/equatable.dart';

import '../../../home/domain/entities/location_entity.dart';
import '../../domain/entities/weather_entity.dart';

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

class LoadLocalWeatherEvent extends WeatherEvent {
  final WeatherEntity? weather;
  final int totalTripDays;

  const LoadLocalWeatherEvent({
    required this.weather,
    required this.totalTripDays,
  });

  @override
  List<Object?> get props => [weather, totalTripDays];
}
