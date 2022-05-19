import 'package:flutter/material.dart';
import 'package:nested_sqflite/Activity.dart';
import 'package:nested_sqflite/date_db_helper.dart';

import 'date_form.dart';

class DateView extends StatefulWidget {
  final Activity activity;

  DateView(this.activity);

  @override
  State<DateView> createState() => _DateViewState();
}

class _DateViewState extends State<DateView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dates: ${widget.activity.name}"),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: DateDbHelper.instance
                  .getDatesList(widget.activity.dateTableName),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  case ConnectionState.done:
                    final List<DateTime> dates =
                        snapshot.data as List<DateTime>;
                    if (dates.isEmpty) {
                      return Text("It's empty");
                    }
                    return ListView.builder(
                      itemCount: dates.length,
                      itemBuilder: (context, index) {
                        final date = dates[index];
                        return Card(
                          child: ListTile(
                            title: Text(
                                "${date.year}, ${date.month}, ${date.day}"),
                            onLongPress: () async {
                              await DateDbHelper.instance.delete(
                                  dateTime: date,
                                  dateTableName: widget.activity.dateTableName);
                              setState(() {});
                            },
                          ),
                        );
                      },
                    );
                  default:
                    return Text("?????");
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) => DateForm(
                        activity: widget.activity,
                      )))
              .then((value) => setState(() {}));
        },
      ),
    );
  }
}
