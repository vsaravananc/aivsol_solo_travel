abstract final class TripPlanTable {
  static const String tableName = 'trip_plans';

  static const String columnId = 'id';
  static const String columnFrom = 'from_location';
  static const String columnTo = 'to_location';
  static const String columnStartDate = 'start_date';
  static const String columnEndDate = 'end_date';
  static const String columnTravelStyle = 'travel_style';
  static const String columnCreatedAt = 'created_at';

  static const String createTableSql = '''
    CREATE TABLE $tableName (
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnFrom TEXT NOT NULL,
      $columnTo TEXT NOT NULL,
      $columnStartDate TEXT NOT NULL,
      $columnEndDate TEXT NOT NULL,
      $columnTravelStyle TEXT NOT NULL,
      $columnCreatedAt TEXT NOT NULL
    )
  ''';
}
