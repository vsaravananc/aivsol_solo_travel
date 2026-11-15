import '../../../../core/error/exceptions.dart';
import '../../domain/entities/current_weather_entity.dart';
import '../../domain/entities/daily_weather_entity.dart';
import '../../domain/entities/weather_entity.dart';

class WeatherModel extends WeatherEntity {
  const WeatherModel({
    required super.currentWeather,
    required super.dailyWeather,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final currentJson = json['current'];
    if (currentJson == null || currentJson is! Map<String, dynamic>) {
      throw const ParsingException(
        'Missing or invalid "current" weather data in API response.',
      );
    }

    final dailyJson = json['daily'];
    if (dailyJson == null || dailyJson is! Map<String, dynamic>) {
      throw const ParsingException(
        'Missing or invalid "daily" weather forecast in API response.',
      );
    }

    final temp = currentJson['temperature_2m'];
    final humidity = currentJson['relative_humidity_2m'];
    final weatherCode = currentJson['weather_code'];

    if (temp == null || humidity == null || weatherCode == null) {
      throw const ParsingException(
        'Incomplete current weather properties in API response.',
      );
    }

    final currentWeather = CurrentWeatherEntity(
      temperature: (temp as num).toDouble(),
      relativeHumidity: (humidity as num).round(),
      weatherCode: (weatherCode as num).round(),
    );

    final times = dailyJson['time'];
    final weatherCodes = dailyJson['weather_code'];
    final maxTemps = dailyJson['temperature_2m_max'];
    final minTemps = dailyJson['temperature_2m_min'];

    if (times is! List ||
        weatherCodes is! List ||
        maxTemps is! List ||
        minTemps is! List) {
      throw const ParsingException(
        'Invalid daily forecast array structure in API response.',
      );
    }

    final length = times.length;
    if (weatherCodes.length != length ||
        maxTemps.length != length ||
        minTemps.length != length) {
      throw const ParsingException(
        'Daily forecast arrays have mismatched lengths.',
      );
    }

    final List<DailyWeatherEntity> dailyWeather = [];
    for (var i = 0; i < length; i++) {
      final timeStr = times[i]?.toString();
      final date = timeStr != null ? DateTime.tryParse(timeStr) : null;
      if (date == null) {
        throw ParsingException(
          'Invalid date format in daily forecast: $timeStr',
        );
      }

      dailyWeather.add(
        DailyWeatherEntity(
          date: date,
          weatherCode: (weatherCodes[i] as num).round(),
          maxTemperature: (maxTemps[i] as num).toDouble(),
          minTemperature: (minTemps[i] as num).toDouble(),
        ),
      );
    }

    return WeatherModel(
      currentWeather: currentWeather,
      dailyWeather: dailyWeather,
    );
  }
}
