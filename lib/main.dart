import 'package:flutter/material.dart';
import 'package:workcheckin/views/json_demo.dart';
import 'package:workcheckin/views/leave_screen.dart';
import 'package:workcheckin/views/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/splash': (BuildContext context)=> SplashScreen(),
        '/jsondemo': (BuildContext context) => JsonDemo(),
      },
    );
  }
}
