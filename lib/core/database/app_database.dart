import 'package:aivsol_solo_travel/core/database/table/trip_history_table.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static const String _dbName = 'aivsol_solo_travel.db';
  static const int _dbVersion = 1;

  static Database? _db;

  static Future<Database> get instance async {
    _db ??= await _open();
    return _db!;
  }

  static Future<Database> _open() async {
    final path = join(await getDatabasesPath(), _dbName);
    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute(TripHistoryTable.createTableSql);
      },
    );
  }

  static Future<void> testing() async {
    final db = await instance;

    final count = await db.rawQuery('SELECT * FROM trip_history');

      final tables = await db.rawQuery('''
      SELECT name
      FROM sqlite_master
      WHERE type = 'table'
      AND name NOT LIKE 'sqlite_%'
    ''');
    debugPrint('Total records: ${count.toString().replaceAll(',', '\n')}');
  }
}
