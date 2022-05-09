import 'package:flutter/material.dart';
import 'package:nested_sqflite/Activity.dart';
import 'package:nested_sqflite/date_db_helper.dart';

class DateForm extends StatelessWidget {
  final Activity activity;

  DateForm({required this.activity});

  TextEditingController _yearController = TextEditingController();
  TextEditingController _monthController = TextEditingController();
  TextEditingController _dayController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New date"),
      ),
      body: Column(
        children: [
          TextField(
            controller: _yearController,
            decoration: InputDecoration(hintText: "Year (yyyy)"),
          ),
          TextField(
            controller: _monthController,
            decoration: InputDecoration(hintText: "Month (1 - 12)"),
          ),
          TextField(
            controller: _dayController,
            decoration: InputDecoration(hintText: "Day (1 - 31)"),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    DateDbHelper.instance.add(
                        dateTableName: activity.dateTableName,
                        dateTime: DateTime.now());
                    Navigator.of(context).pop();
                  },
                  child: Text("Now")),
              ElevatedButton(
                  onPressed: () {
                    DateDbHelper.instance.add(
                        dateTableName: activity.dateTableName,
                        dateTime: DateTime.utc(
                          int.tryParse(_yearController.text)!,
                          int.tryParse(_monthController.text)!,
                          int.tryParse(_dayController.text)!,
                        ));
                    Navigator.of(context).pop();
                  },
                  child: Text("Save")),
            ],
          )
        ],
      ),
    );
  }
}
