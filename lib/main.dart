import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:third_eye/view/homepage.dart';
import 'package:third_eye/view/infopage.dart';

final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
bool _firstTime = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await checkFirstTime();
  runApp(
    MyApp(),
  );
}

Future<void> checkFirstTime() async {
  _firstTime = await _prefs.then((SharedPreferences prefs) {
    return (prefs.getBool('firstTime') ?? true);
  });
  if (_firstTime) {
    final SharedPreferences prefs = await _prefs;
    prefs.setBool('firstTime', false);
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Third Eye',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: _firstTime ? InfoPage() : HomePage(),
      routes: {
        '/info': (context) => InfoPage(),
        '/home': (context) => HomePage(),
      },
    );
  }
}
