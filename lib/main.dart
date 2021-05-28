import 'package:daily_tracker/pages/map.dart';
import 'package:daily_tracker/util/locationHistory.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'util/debug.dart';

LocationHistory locationHistory;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  locationHistory = LocationHistory();

  runApp(MyApp(preferences));
}

class MyApp extends StatelessWidget {
  final SharedPreferences preferences;
  MyApp(this.preferences);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
      home: MyHomePage(preferences, title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage(this.preferences, {Key key, this.title}) : super(key: key);

  final String title;
  final SharedPreferences preferences;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    MapPage mapPage = MapPage(widget.preferences);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: mapPage,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          widget.preferences.setString('LocationHistory', "{\"locations\":[]}");
          mapPage.loadLocationHistory();
          Debug.Log('Reset Historys', color: DColor.magenta);
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
