import 'dart:convert';

import 'package:aivsol_solo_travel/core/database/app_database.dart';
import 'package:aivsol_solo_travel/core/database/table/trip_history_table.dart';
import 'package:aivsol_solo_travel/core/enums/travel_style.dart';
import 'package:aivsol_solo_travel/feature/detail/domain/entities/budget_entity.dart';
import 'package:aivsol_solo_travel/feature/detail/domain/entities/trip_history_entity.dart';
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

  Future<List<TripHistoryEntity>> getAllTripHistory() async {
    final db = await AppDatabase.instance;
    final rows = await db.query(
      TripHistoryTable.tableName,
      orderBy: '${TripHistoryTable.columnCreatedAt} DESC',
    );
    return rows.map(_rowToEntity).toList();
  }

  Future<List<TripHistoryEntity>> getRecentTripHistory({
    required int limit,
  }) async {
    final db = await AppDatabase.instance;
    final rows = await db.query(
      TripHistoryTable.tableName,
      orderBy: '${TripHistoryTable.columnCreatedAt} DESC',
      limit: limit,
    );
    return rows.map(_rowToEntity).toList();
  }

  Future<TripHistoryEntity?> getTripHistoryById(int id) async {
    final db = await AppDatabase.instance;
    final rows = await db.query(
      TripHistoryTable.tableName,
      where: '${TripHistoryTable.columnId} = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return _rowToEntity(rows.first);
  }

  TripHistoryEntity _rowToEntity(Map<String, dynamic> row) {
    final styleName = row[TripHistoryTable.columnTravelStyle] as String;
    final travelStyle = TravelStyle.values.firstWhere(
      (e) => e.name == styleName,
      orElse: () => TravelStyle.standard,
    );

    return TripHistoryEntity(
      id: row[TripHistoryTable.columnId] as int,
      createdAt: DateTime.parse(
        row[TripHistoryTable.columnCreatedAt] as String,
      ),
      fromLocation: row[TripHistoryTable.columnFrom] as String,
      toLocation: row[TripHistoryTable.columnTo] as String,
      fromLat: (row[TripHistoryTable.columnFromLat] as num).toDouble(),
      fromLong: (row[TripHistoryTable.columnFromLong] as num).toDouble(),
      toLat: (row[TripHistoryTable.columnToLat] as num).toDouble(),
      toLong: (row[TripHistoryTable.columnToLong] as num).toDouble(),
      startDate: DateTime.parse(
        row[TripHistoryTable.columnStartDate] as String,
      ),
      endDate: DateTime.parse(row[TripHistoryTable.columnEndDate] as String),
      travelStyle: travelStyle,
      travelCost: (row[TripHistoryTable.columnTravelCost] as num).toDouble(),
      hotelCost: (row[TripHistoryTable.columnHotelCost] as num).toDouble(),
      foodCost: (row[TripHistoryTable.columnFoodCost] as num).toDouble(),
      localTransportCost:
          (row[TripHistoryTable.columnLocalTransportCost] as num).toDouble(),
      totalCost: (row[TripHistoryTable.columnTotalCost] as num).toDouble(),
      distanceKm: (row[TripHistoryTable.columnDistanceKm] as num).toDouble(),
      tripDays: row[TripHistoryTable.columnTripDays] as int,
      hotelNights: row[TripHistoryTable.columnHotelNights] as int,
      weatherTemperature:
          (row[TripHistoryTable.columnWeatherTemperature] as num?)?.toDouble(),
      weatherHumidity: row[TripHistoryTable.columnWeatherHumidity] as int?,
      weatherCode: row[TripHistoryTable.columnWeatherCode] as int?,
      dailyWeatherJson: row[TripHistoryTable.columnDailyWeatherJson] as String?,
    );
  }
}
