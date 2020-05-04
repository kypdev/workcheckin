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
import 'package:workcheckin/models/size_config.dart';
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
        context, MaterialPageRoute(builder: (context) => CheckinScreen()));
  }

  _leave() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LeaveScreen()));
  }

  _history() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HistoryScreen()));
  }

  _logout() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      sharedPreferences.clear();
      sharedPreferences.setString('app_version', '0.0.01');

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => SigninScreen()));
    });
  }

  _bossLeave() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => BossScreen()));
  }

  setMessage() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var msg = sharedPreferences.getString('userMsg');
    message = jsonDecode(msg);
  }

  _notiBoss() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => NotiBossScreen()));
  }

  _showProfile() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ProfileScreen()));
  }

  _historyCheckin() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HistoryCheckin()));
  }

  @override
  void initState() {
    super.initState();
    setMessage();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var sizeHor = SizeConfig.safeBlockHorizontal;
    var sizeVer = SizeConfig.safeBlockVertical;
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: sizeVer * 5.8,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Color(0xff07395A),
                    ),
                    child: Image.asset(
                      'assets/images/tot.png',
                      alignment: Alignment.topRight,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: sizeHor * 4,
                      right: sizeHor * 4,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        InkWell(
                          onTap: _notiBoss,
                          child: Image.asset(
                            'assets/images/noti.png',
                            width: sizeHor * 30,
                          ),
                        ),
                        InkWell(
                          onTap: _logout,
                          child: Image.asset(
                            'assets/images/logout.png',
                            width: sizeHor * 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/images/card-menu.png',
                        width: sizeHor * 90,
                        height: sizeVer * 48,
                        filterQuality: FilterQuality.high,
                        excludeFromSemantics: true,
                        fit: BoxFit.fill,
                      ),
                      Column(
                        children: <Widget>[
                          SizedBox(height: sizeVer * 5),
                          Padding(
                            padding: EdgeInsets.only(
                                left: sizeHor * 14, right: sizeHor * 14),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                InkWell(
                                  onTap: _employee,
                                  child: Image.asset(
                                    'assets/images/check.png',
                                    width: sizeHor * 30,
                                  ),
                                ),
                                SizedBox(width: sizeHor * 2.5),
                                InkWell(
                                  onTap: _historyCheckin,
                                  child: Image.asset(
                                    'assets/images/his-time.png',
                                    width: sizeHor * 30,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: sizeVer * 2.5),
                          Padding(
                            padding: EdgeInsets.only(
                                left: sizeHor * 14, right: sizeHor * 14),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                InkWell(
                                  onTap: _leave,
                                  child: Image.asset(
                                    'assets/images/leave.png',
                                    width: sizeHor * 30,
                                  ),
                                ),
                                SizedBox(width: sizeHor * 4),
                                InkWell(
                                  onTap: _history,
                                  child: Image.asset(
                                    'assets/images/his-leave.png',
                                    width: sizeHor * 30,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: sizeVer * 2.5),
                          InkWell(
                            onTap: _showProfile,
                            child: Image.asset(
                              'assets/images/pro.png',
                              width: sizeHor * 30,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: sizeVer * 3),
                  Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/images/boss-card.png',
                        width: sizeHor * 90,
                        height: sizeVer * 28,
                        filterQuality: FilterQuality.high,
                        excludeFromSemantics: true,
                        fit: BoxFit.fill,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: sizeVer * 4),
                        child: InkWell(
                          onTap: _bossLeave,
                          child: Image.asset(
                            'assets/images/report.png',
                            width: sizeHor * 30,
                            filterQuality: FilterQuality.high,
                            excludeFromSemantics: true,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: sizeVer * 4),
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
