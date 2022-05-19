import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DateDbHelper {
  DateDbHelper.privateConstructor();

  static final DateDbHelper instance = DateDbHelper.privateConstructor();

  Future<Database> get database async => _database ??= await _initDatabase();
  static Database? _database;

  static const String tableId = 'id';
  static const String tableYear = 'year';
  static const String tableMonth = 'month';
  static const String tableDay = 'day';

  Future<Database> _initDatabase() async {
    debugPrint("Starting dates.db");
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'dates.db');
    return await openDatabase(
      path,
      version: 1,
    );
  }

  Future createTable({required String dateTableName}) async {
    Database db = await instance.database;
    debugPrint("Creating $dateTableName");
    await db.execute('''
      CREATE TABLE $dateTableName(
        $tableId INTEGER PRIMARY KEY,
        $tableYear INTEGER,
        $tableMonth INTEGER,
        $tableDay INTEGER
      )
    ''');
  }

  //Not being used right now, but I will leave it here for future reference
  Future<void> clearTable({required String dateTableName}) async {
    debugPrint("Clearing $dateTableName");
    Database db = await instance.database;
    db.execute("DELETE FROM $dateTableName");
    db.execute("VACUUM");
    debugPrint("$dateTableName was cleared");
  }

  Future<void> dropTable({required String dateTableName}) async {
    debugPrint("Dropping $dateTableName");
    Database db = await instance.database;
    db.execute("DROP TABLE IF EXISTS $dateTableName");
    debugPrint("$dateTableName was dropped");
  }

  Future<int> addDate(
      {required String dateTableName, required DateTime dateTime}) async {
    Database db = await instance.database;
    return await db.insert(
      dateTableName,
      {
        DateDbHelper.tableId: null,
        DateDbHelper.tableYear: dateTime.year,
        DateDbHelper.tableMonth: dateTime.month,
        DateDbHelper.tableDay: dateTime.day,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Searches the table for a matching DateTime and deletes it if found
  Future<int> delete(
      {required String dateTableName, required DateTime dateTime}) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(dateTableName);
    int? id;
    for (Map<String, dynamic> map in maps) {
      if (map[tableYear] == dateTime.year &&
          map[tableMonth] == dateTime.month &&
          map[tableDay] == dateTime.day) {
        id = map[tableId];
        break;
      }
    }
    if (id != null) {
      debugPrint("Deleting date from table");
      return await db.delete(dateTableName, where: 'id = ?', whereArgs: [id]);
    } else {
      debugPrint("Date not found in table, unable to delete");
      return 0;
    }
  }

  // Return all dates from a table as a list of DateTime
  Future<List<DateTime>> getDatesList(String dateTableName) async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(dateTableName);
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
