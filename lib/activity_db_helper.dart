import 'package:flutter/material.dart';
import 'package:nested_sqflite/Activity.dart';
import 'package:nested_sqflite/date_db_helper.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ActivityDbHelper {
  ActivityDbHelper.privateConstructor();

  static final ActivityDbHelper instance = ActivityDbHelper.privateConstructor();

  static Database? _database;

  static const String table = 'activities';
  static const String tableId = 'id';
  static const String tableName = 'name';
  static const String dateTableName = 'dtn';

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'activities.db');
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
        $tableName TEXT,
        $dateTableName TEXT
      )
    ''');
  }

  Future<int> add(Activity activity) async {
    DateDbHelper.instance.initDatabase(activity.dateTableName);
    Database db = await instance.database;
    debugPrint('add: ${activity.toMap().toString()}');
    return await db.insert(
      table,
      activity.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> delete(int id) async { //TODO: fix this, it currently requires two long presses to delete
    Activity activity = await getOneActivity(id);
    DateDbHelper.instance.clearTable(dateTableName: activity.dateTableName);
    Database db = await instance.database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  Future<Activity> getOneActivity(int id) async {
    List<Activity> activities = await instance.getActivities();
    late Activity selectedActivity;
    for(Activity activity in activities){
      if(activity.id == id){
        selectedActivity = activity;
        break;
      }
    }
    return selectedActivity;
  }

  Future<List<Activity>> getActivities() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(table);

    return List.generate(maps.length, (i) {
      return Activity(
        id: maps[i][tableId],
        name: maps[i][tableName],
      );
    });
  }

  // Future<int> update(Activity activity) async {
  //   Database db = await instance.database;
  //   return await db.update(table, note.toMap(),
  //       where: 'id = ?', whereArgs: [note.id]);
  // } //TODO: figure out how to implement this without breaking everything

}