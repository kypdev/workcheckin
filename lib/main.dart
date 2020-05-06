import 'package:flutter/material.dart';
import 'package:workcheckin/views/splash_screen.dart';

void main() {
  ErrorWidget.builder = (FlutterErrorDetails details) => Container();

  runApp(
    MyApp(),
  );
}

final _kanit = 'Kanit';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      showSemanticsDebugger: false,
      home: SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/splash': (BuildContext context) => SplashScreen(),
      },
      theme: ThemeData(
        primaryColor: Color(0xff07395A),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(
            fontFamily: _kanit,
          ),
          errorStyle: TextStyle(
            fontFamily: _kanit,
          ),
        ),
        textTheme: TextTheme(),
        fontFamily: _kanit,
      ),
    );
  }
}
