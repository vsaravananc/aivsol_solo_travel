import 'dart:convert';
import 'package:equatable/equatable.dart';

import '../../../../core/enums/travel_style.dart';
import 'budget_entity.dart';
import 'current_weather_entity.dart';
import 'daily_weather_entity.dart';
import 'weather_entity.dart';

class TripHistoryEntity extends Equatable {
  final int id;
  final DateTime createdAt;
  final String fromLocation;
  final String toLocation;
  final double fromLat;
  final double fromLong;
  final double toLat;
  final double toLong;
  final DateTime startDate;
  final DateTime endDate;
  final TravelStyle travelStyle;
  final double travelCost;
  final double hotelCost;
  final double foodCost;
  final double localTransportCost;
  final double totalCost;
  final double distanceKm;
  final int tripDays;
  final int hotelNights;
  final double? weatherTemperature;
  final int? weatherHumidity;
  final int? weatherCode;
  final String? dailyWeatherJson;

  const TripHistoryEntity({
    required this.id,
    required this.createdAt,
    required this.fromLocation,
    required this.toLocation,
    required this.fromLat,
    required this.fromLong,
    required this.toLat,
    required this.toLong,
    required this.startDate,
    required this.endDate,
    required this.travelStyle,
    required this.travelCost,
    required this.hotelCost,
    required this.foodCost,
    required this.localTransportCost,
    required this.totalCost,
    required this.distanceKm,
    required this.tripDays,
    required this.hotelNights,
    this.weatherTemperature,
    this.weatherHumidity,
    this.weatherCode,
    this.dailyWeatherJson,
  });

  BudgetEntity get toBudgetEntity => BudgetEntity(
        travelCost: travelCost,
        hotelCost: hotelCost,
        foodCost: foodCost,
        localTransportCost: localTransportCost,
        totalCost: totalCost,
        distanceInKm: distanceKm,
        tripDays: tripDays,
        hotelNights: hotelNights,
      );

  WeatherEntity? get toWeatherEntity {
    if (weatherTemperature == null) return null;

    final currentWeather = CurrentWeatherEntity(
      temperature: weatherTemperature!,
      relativeHumidity: weatherHumidity ?? 0,
      weatherCode: weatherCode ?? 0,
    );

    List<DailyWeatherEntity> dailyList = [];
    if (dailyWeatherJson != null && dailyWeatherJson!.isNotEmpty) {
      try {
        final decoded = json.decode(dailyWeatherJson!) as List;
        dailyList = decoded.map((item) {
          final map = item as Map<String, dynamic>;
          return DailyWeatherEntity(
            date: DateTime.parse(map['date'] as String),
            weatherCode: map['weatherCode'] as int,
            maxTemperature: (map['maxTemperature'] as num).toDouble(),
            minTemperature: (map['minTemperature'] as num).toDouble(),
          );
        }).toList();
      } catch (_) {}
    }

    return WeatherEntity(
      currentWeather: currentWeather,
      dailyWeather: dailyList,
    );
  }

  @override
  List<Object?> get props => [
        id,
        createdAt,
        fromLocation,
        toLocation,
        fromLat,
        fromLong,
        toLat,
        toLong,
        startDate,
        endDate,
        travelStyle,
        travelCost,
        hotelCost,
        foodCost,
        localTransportCost,
        totalCost,
        distanceKm,
        tripDays,
        hotelNights,
        weatherTemperature,
        weatherHumidity,
        weatherCode,
        dailyWeatherJson,
      ];
}
