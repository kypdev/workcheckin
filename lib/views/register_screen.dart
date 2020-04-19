import 'package:flutter/material.dart';

final _kanit = 'Kanit';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('สมัครสมาชิก', style: TextStyle(fontFamily: _kanit),),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          
        ],
      ),
      
    );
  }
}