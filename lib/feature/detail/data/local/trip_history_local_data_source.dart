import 'dart:convert';
import 'package:aivsol_solo_travel/core/database/app_database.dart';
import 'package:aivsol_solo_travel/core/database/table/trip_history_table.dart';
import 'package:aivsol_solo_travel/core/enums/travel_style.dart';
import 'package:aivsol_solo_travel/feature/detail/domain/entities/budget_entity.dart';
import 'package:aivsol_solo_travel/feature/detail/domain/entities/weather_entity.dart';
import 'package:aivsol_solo_travel/feature/home/domain/entities/location_entity.dart';

class TripHistoryLocalDataSource {
  Future<int> saveTripHistory({
    required LocationEntity from,
    required LocationEntity to,
    required DateTime startDate,
    required DateTime endDate,
    required TravelStyle travelStyle,
    required BudgetEntity budget,
    WeatherEntity? weather,
  }) async {
    final db = await AppDatabase.instance;
    final String? dailyWeatherJson = weather == null
        ? null
        : json.encode(
            weather.dailyWeather
                .map(
                  (d) => {
                    'date': d.date.toIso8601String(),
                    'weatherCode': d.weatherCode,
                    'maxTemperature': d.maxTemperature,
                    'minTemperature': d.minTemperature,
                  },
                )
                .toList(),
          );

    final row = <String, Object?>{
      TripHistoryTable.columnCreatedAt: DateTime.now().toIso8601String(),
      TripHistoryTable.columnFrom: from.name,
      TripHistoryTable.columnTo: to.name,
      TripHistoryTable.columnFromLat: from.latitude,
      TripHistoryTable.columnFromLong: from.longitude,
      TripHistoryTable.columnToLat: to.latitude,
      TripHistoryTable.columnToLong: to.longitude,
      TripHistoryTable.columnStartDate: startDate.toIso8601String(),
      TripHistoryTable.columnEndDate: endDate.toIso8601String(),
      TripHistoryTable.columnTravelStyle: travelStyle.name,
      TripHistoryTable.columnTravelCost: budget.travelCost,
      TripHistoryTable.columnHotelCost: budget.hotelCost,
      TripHistoryTable.columnFoodCost: budget.foodCost,
      TripHistoryTable.columnLocalTransportCost: budget.localTransportCost,
      TripHistoryTable.columnTotalCost: budget.totalCost,
      TripHistoryTable.columnDistanceKm: budget.distanceInKm,
      TripHistoryTable.columnTripDays: budget.tripDays,
      TripHistoryTable.columnHotelNights: budget.hotelNights,
      TripHistoryTable.columnWeatherTemperature:
          weather?.currentWeather.temperature,
      TripHistoryTable.columnWeatherHumidity:
          weather?.currentWeather.relativeHumidity,
      TripHistoryTable.columnWeatherCode: weather?.currentWeather.weatherCode,
      TripHistoryTable.columnDailyWeatherJson: dailyWeatherJson,
    };
    return db.insert(TripHistoryTable.tableName, row);
  }

  Future<List<Map<String, dynamic>>> getAllTripHistory() async {
    final db = await AppDatabase.instance;
    return db.query(
      TripHistoryTable.tableName,
      orderBy: '${TripHistoryTable.columnCreatedAt} DESC',
    );
  }

  Future<Map<String, dynamic>?> getTripHistoryById(int id) async {
    final db = await AppDatabase.instance;
    final rows = await db.query(
      TripHistoryTable.tableName,
      where: '${TripHistoryTable.columnId} = ?',
      whereArgs: [id],
      limit: 1,
    );
    return rows.isEmpty ? null : rows.first;
  }
}
