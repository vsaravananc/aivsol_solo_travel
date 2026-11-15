import 'package:aivsol_solo_travel/core/database/app_database.dart';
import 'package:aivsol_solo_travel/core/enums/travel_style.dart';
import 'package:aivsol_solo_travel/core/database/table/trip_plan_table.dart';
import 'package:aivsol_solo_travel/feature/home/presentation/bloc/home_state.dart';

class TripPlanLocalDataSource {
  Future<int> saveTripPlan(HomeState state) async {
    final db = await AppDatabase.instance;
    return db.insert(
      TripPlanTable.tableName,
      {
        TripPlanTable.columnFrom: state.from!,
        TripPlanTable.columnTo: state.to!,
        TripPlanTable.columnStartDate: state.startDate!.toIso8601String(),
        TripPlanTable.columnEndDate: state.endDate!.toIso8601String(),
        TripPlanTable.columnTravelStyle: state.travelStyle!.name,
        TripPlanTable.columnCreatedAt: DateTime.now().toIso8601String(),
      },
    );
  }

  Future<List<HomeState>> getAllTripPlans() async {
    final db = await AppDatabase.instance;
    final rows = await db.query(
      TripPlanTable.tableName,
      orderBy: '${TripPlanTable.columnCreatedAt} DESC',
    );
    return rows.map(_rowToState).toList();
  }

  Future<int> deleteTripPlan(int id) async {
    final db = await AppDatabase.instance;
    return db.delete(
      TripPlanTable.tableName,
      where: '${TripPlanTable.columnId} = ?',
      whereArgs: [id],
    );
  }

  HomeState _rowToState(Map<String, dynamic> row) {
    return HomeState(
      from: row[TripPlanTable.columnFrom] as String,
      to: row[TripPlanTable.columnTo] as String,
      startDate: DateTime.parse(row[TripPlanTable.columnStartDate] as String),
      endDate: DateTime.parse(row[TripPlanTable.columnEndDate] as String),
      travelStyle: TravelStyle.values.firstWhere(
        (s) => s.name == row[TripPlanTable.columnTravelStyle],
        orElse: () => TravelStyle.standard,
      ),
    );
  }
}
