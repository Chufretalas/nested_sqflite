import 'package:flutter/material.dart';
import 'package:nested_sqflite/Activity.dart';
import 'package:nested_sqflite/activity_db_helper.dart';
import 'package:nested_sqflite/date_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nested SQL test',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _activityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nested sqflite v2"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _activityController,
              decoration: InputDecoration(labelText: "New activity"),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await ActivityDbHelper.instance
                  .add(Activity(name: _activityController.text));
              _activityController.text = "";
              setState(() {});
            },
            child: const Text("Save"),
          ),
          FutureBuilder(
            future: ActivityDbHelper.instance.getActivities(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                case ConnectionState.done:
                  final List<Activity> activities =
                      snapshot.data as List<Activity>;
                  return Expanded(
                      child: ListView.builder(
                    itemCount: activities.length,
                    itemBuilder: (context, index) {
                      final activity = activities[index];
                      return Card(
                        child: ListTile(
                          title: Text(activity.name),
                          onLongPress: () async {
                            await ActivityDbHelper.instance.delete(activity.id!);
                            setState(() {});
                          },
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => DateView(activity)));
                          },
                        ),
                      );
                    },
                  ));
                default:
                  return Text("?????");
              }
            },
          ),
        ],
      ),
    );
  }
}
