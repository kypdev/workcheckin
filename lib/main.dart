import 'package:flutter/material.dart';
import 'package:workcheckin/views/splash_screen.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/splash': (BuildContext context)=> SplashScreen(),
      },
    );
  }
}
