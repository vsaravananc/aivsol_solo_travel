import 'package:equatable/equatable.dart';

class DailyWeatherEntity extends Equatable {
  final DateTime date;
  final int weatherCode;
  final double maxTemperature;
  final double minTemperature;

  const DailyWeatherEntity({
    required this.date,
    required this.weatherCode,
    required this.maxTemperature,
    required this.minTemperature,
  });

  @override
  List<Object?> get props => [
        date,
        weatherCode,
        maxTemperature,
        minTemperature,
      ];
}
