import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DateDbHelper {
  DateDbHelper.privateConstructor();

  static final DateDbHelper instance = DateDbHelper.privateConstructor();

  static late String table;
  static const String tableId = 'id';
  static const String tableYear = 'year';
  static const String tableMonth = 'month';
  static const String tableDay = 'day';

  Future<Database> initDatabase(String dateTableName) async {
    debugPrint("Starting: $dateTableName");
    table = dateTableName;
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, '$table.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table(
        $tableId INTEGER PRIMARY KEY,
        $tableYear INTEGER,
        $tableMonth INTEGER,
        $tableDay INTEGER
      )
    ''');
  }
  
  Future<void> clearTable({required String dateTableName}) async {
    debugPrint("Clearing $dateTableName");
    Database db = await initDatabase(dateTableName);
    db.execute("DELETE FROM $dateTableName");
    db.execute("VACUUM");
    debugPrint("$dateTableName was cleared");
  }

  Future<int> add(
      {required String dateTableName, required DateTime dateTime}) async {
    Database db = await initDatabase(dateTableName);
    return await db.insert(
      table,
      {
        DateDbHelper.tableId: null,
        DateDbHelper.tableYear: dateTime.year,
        DateDbHelper.tableMonth: dateTime.month,
        DateDbHelper.tableDay: dateTime.day,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> delete(
      {required String dateTableName, required DateTime dateTime}) async {
    Database db = await initDatabase(dateTableName);
    List<Map<String, dynamic>> maps = await _getDates(dateTableName);
    int id = 0;
    for (Map<String, dynamic> map in maps) {
      if (map[tableYear] == dateTime.year &&
          map[tableMonth] == dateTime.month &&
          map[tableDay] == dateTime.day) {
        id = map[tableId];
        break;
      }
    }
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> _getDates(String dateTableName) async {
    Database db = await initDatabase(dateTableName);
    final List<Map<String, dynamic>> maps = await db.query(table);
    return maps;
  }

  Future<List<DateTime>> getDateTimes(String dateTableName) async {
    Database db = await initDatabase(dateTableName);
    final List<Map<String, dynamic>> maps = await db.query(table);
    return List.generate(maps.length, (i) {
      return DateTime.utc(
        maps[i][tableYear],
        maps[i][tableMonth],
        maps[i][tableDay],
      );
    });
  }

// Future<int> update(Note note) async {
//   Database db = await instance.database;
//   return await db
//       .update(table, note.toMap(), where: 'id = ?', whereArgs: [note.id]);
// } //TODO: I don't need this for now
}
