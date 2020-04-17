import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workcheckin/views/empolyee_screen.dart';
import 'package:workcheckin/views/history_screen.dart';
import 'package:workcheckin/views/signin_screen.dart';
import 'leave_screen.dart';

final _kanit = 'Kanit';

class HomeScreen extends StatefulWidget {
  Map<String, dynamic> message;
  HomeScreen({Key key, this.message}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SharedPreferences sharedPreferences;
  var message;
  _employee() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EmployeeScreen(
                  message: widget.message,
                )));
    print(widget.message);
  }

  _leave() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LeaveScreen(
                  message: widget.message,
                )));
    print(widget.message);
  }

  _history() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HistoryScreen(
                  message: widget.message,
                )));
    print(widget.message);
  }

  _logout() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      sharedPreferences.clear();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SigninScreen()));
    });
  }

  setMessage() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var msg = sharedPreferences.getString('userMsg');
    message = jsonDecode(msg);
    print('aaaa: ' + jsonEncode(message));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
setMessage();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              btnMenu(
                btnName: 'ลงเวลาการทำงาน',
                color: Colors.blueAccent,
                action: _employee,
              ),
              btnMenu(
                btnName: 'ลางาน',
                color: Colors.greenAccent,
                action: _leave,
              ),
              btnMenu(
                btnName: 'ประวัติ',
                color: Colors.deepOrange,
                action: _history,
              ),

              btnMenu(
                btnName: 'logout',
                color: Colors.deepOrange,
                action: _logout,
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget btnMenu({
    btnName,
    action,
    color,
  }) {
    return Padding(
      padding: EdgeInsets.only(left: 50, right: 50),
      child: RaisedButton(
        color: color,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              btnName,
              style: TextStyle(
                fontFamily: _kanit,
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ],
        ),
        onPressed: action,
      ),
    );
  }
}
