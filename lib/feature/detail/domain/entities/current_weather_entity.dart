import 'package:equatable/equatable.dart';

class CurrentWeatherEntity extends Equatable {
  final double temperature;
  final int relativeHumidity;
  final int weatherCode;

  const CurrentWeatherEntity({
    required this.temperature,
    required this.relativeHumidity,
    required this.weatherCode,
  });

  @override
  List<Object?> get props => [temperature, relativeHumidity, weatherCode];
}
