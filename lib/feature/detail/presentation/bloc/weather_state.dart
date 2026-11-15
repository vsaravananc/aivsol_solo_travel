import 'package:equatable/equatable.dart';

import '../../domain/entities/weather_entity.dart';

sealed class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object?> get props => [];
}

class WeatherInitial extends WeatherState {
  const WeatherInitial();
}

class WeatherLoading extends WeatherState {
  const WeatherLoading();
}

class WeatherSuccess extends WeatherState {
  final WeatherEntity weather;
  final int totalTripDays;

  const WeatherSuccess({
    required this.weather,
    required this.totalTripDays,
  });

  @override
  List<Object?> get props => [
        weather,
        totalTripDays,
      ];
}

class WeatherFailure extends WeatherState {
  final String errorMessage;

  const WeatherFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
