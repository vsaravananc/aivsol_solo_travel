abstract final class TripHistoryTable {
  static const String tableName = 'trip_history';
  static const String columnId = 'id';
  static const String columnCreatedAt = 'created_at';
  static const String columnFrom = 'from_location';
  static const String columnTo = 'to_location';
  static const String columnFromLat = 'from_lat';
  static const String columnFromLong = 'from_long';
  static const String columnToLat = 'to_lat';
  static const String columnToLong = 'to_long';
  static const String columnStartDate = 'start_date';
  static const String columnEndDate = 'end_date';
  static const String columnTravelStyle = 'travel_style';
  static const String columnTravelCost = 'travel_cost';
  static const String columnHotelCost = 'hotel_cost';
  static const String columnFoodCost = 'food_cost';
  static const String columnLocalTransportCost = 'local_transport_cost';
  static const String columnTotalCost = 'total_cost';
  static const String columnDistanceKm = 'distance_km';
  static const String columnTripDays = 'trip_days';
  static const String columnHotelNights = 'hotel_nights';
  static const String columnWeatherTemperature = 'weather_temperature';
  static const String columnWeatherHumidity = 'weather_humidity';
  static const String columnWeatherCode = 'weather_code';
  static const String columnDailyWeatherJson = 'daily_weather_json';


  static const String createTableSql = '''
    CREATE TABLE $tableName (
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnCreatedAt TEXT NOT NULL,
      $columnFrom TEXT NOT NULL,
      $columnTo TEXT NOT NULL,
      $columnFromLat REAL NOT NULL,
      $columnFromLong REAL NOT NULL,
      $columnToLat REAL NOT NULL,
      $columnToLong REAL NOT NULL,
      $columnStartDate TEXT NOT NULL,
      $columnEndDate TEXT NOT NULL,
      $columnTravelStyle TEXT NOT NULL,
      $columnTravelCost REAL NOT NULL,
      $columnHotelCost REAL NOT NULL,
      $columnFoodCost REAL NOT NULL,
      $columnLocalTransportCost REAL NOT NULL,
      $columnTotalCost REAL NOT NULL,
      $columnDistanceKm REAL NOT NULL,
      $columnTripDays INTEGER NOT NULL,
      $columnHotelNights INTEGER NOT NULL,
      $columnWeatherTemperature REAL,
      $columnWeatherHumidity INTEGER,
      $columnWeatherCode INTEGER,
      $columnDailyWeatherJson TEXT
    )
  ''';
}
