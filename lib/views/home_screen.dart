import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workcheckin/views/boss_screen.dart';
import 'package:workcheckin/views/checkin_screen.dart';
import 'package:workcheckin/views/history_checkin.dart';
import 'package:workcheckin/views/history_screen.dart';
import 'package:workcheckin/views/noti_boss_screen.dart';
import 'package:workcheckin/views/profile_screen.dart';
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
    Navigator.push(context, MaterialPageRoute(builder: (context) => CheckinScreen()));
  }

  _leave() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => LeaveScreen()));
  }

  _history() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryScreen()));
  }

  _logout() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      sharedPreferences.clear();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SigninScreen()));
    });
  }

  _bossLeave() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => BossScreen()));
  }

  setMessage() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var msg = sharedPreferences.getString('userMsg');
    message = jsonDecode(msg);
  }

  _notiBoss() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => NotiBossScreen()));
  }

  _showProfile() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
  }

  _historyCheckin() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryCheckin()));
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
        body: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bg.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height / 17.2,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/nav.png'),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 20, top: 10),
                        child: GestureDetector(
                          onTap: _notiBoss,
                          child: Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/noti.png'),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20, top: 10),
                        child: GestureDetector(
                          onTap: _logout,
                          child: Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/logout.png'),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.1,
                    height: MediaQuery.of(context).size.height / 2.2,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/card-menu.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 60, left: 50),
                              child: GestureDetector(
                                onTap: _employee,
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage('assets/images/check.png'),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 60, right: 50),
                              child: GestureDetector(
                                onTap: _historyCheckin,
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage('assets/images/his-time.png'),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 50, right: 50),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              GestureDetector(
                                onTap: _leave,
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage('assets/images/leave.png'),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: _history,
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage('assets/images/his-leave.png'),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: _showProfile,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/pro.png'),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: _bossLeave,
                    child: Container(
                      height: MediaQuery.of(context).size.height / 3.15,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/boss-menu.png'),
                        ),
                      ),
                      child: Column(
                        children: <Widget>[
                          // Padding(
                          //   padding: const EdgeInsets.only(top: 70),
                          //   child: Container(
                          //     width: 120,
                          //     height: 120,
                          //     decoration: BoxDecoration(
                          //       image: DecorationImage(
                          //         image: AssetImage('assets/images/report.png'),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
