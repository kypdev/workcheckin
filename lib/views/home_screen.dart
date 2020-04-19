import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workcheckin/views/boss_screen.dart';
import 'package:workcheckin/views/checkin_screen.dart';
import 'package:workcheckin/views/history_screen.dart';
import 'package:workcheckin/views/noti_screen.dart';
import 'package:workcheckin/views/signin_screen.dart';
import 'leave_screen.dart';

final _kanit = 'Kanit';

class HomeScreen extends StatefulWidget {
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
            builder: (context) => CheckinScreen(
                )));
    
  }

  _leave() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LeaveScreen()));
    
  }

  _history() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HistoryScreen(
                )));
  
  }

  

  _logout() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      sharedPreferences.clear();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => SigninScreen()));
    });
  }

  _bossLeave(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>BossScreen()));
  }
  _noti(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=> NotiScreen()));
  }

  setMessage() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var msg = sharedPreferences.getString('userMsg');
    message = jsonDecode(msg);
    print('aaaa: ' + jsonEncode(message));
  }

  @override
  void initState() {
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
                btnName: 'ประวัติการลา',
                color: Colors.deepOrange,
                action: _history,
              ),

              btnMenu(
                btnName: 'ประวัติการลา(หัวหน้า)',
                color: Colors.deepOrange,
                action: _bossLeave,
              ),

              btnMenu(
                btnName: 'แจ้งเตือน',
                color: Colors.deepOrange,
                action: _noti,
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
