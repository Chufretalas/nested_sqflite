import 'package:sqflite/sqflite.dart';

import 'activity_db_helper.dart';
import 'date_db_helper.dart';

class Activity {
  int? id;
  String name;
  late String dateTableName;

  Activity({
    this.id,
    required this.name,
  }) {
    this.dateTableName = this.name + "DB";
  }

  Map<String, dynamic> toMap() {
    return {
      ActivityDbHelper.tableId: id,
      ActivityDbHelper.tableName: name,
      ActivityDbHelper.dateTableName: dateTableName,
    };
  }
}
