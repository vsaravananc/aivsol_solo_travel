import 'package:equatable/equatable.dart';

import 'current_weather_entity.dart';
import 'daily_weather_entity.dart';

class WeatherEntity extends Equatable {
  final CurrentWeatherEntity currentWeather;
  final List<DailyWeatherEntity> dailyWeather;

  const WeatherEntity({
    required this.currentWeather,
    required this.dailyWeather,
  });

  @override
  List<Object?> get props => [currentWeather, dailyWeather];
}
