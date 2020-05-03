import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workcheckin/models/notification_model.dart';

final _kanit = 'Kanit';

class NotiScreen extends StatefulWidget {
  @override
  _NotiScreenState createState() => _NotiScreenState();
}

class _NotiScreenState extends State<NotiScreen> {
  SharedPreferences sharedPreferences;

  Future<List<BossNotifyModel>> _getNotiList() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var msg = jsonDecode(sharedPreferences.getString('userMsg'));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'แจ้งเตือน',
          style: TextStyle(fontFamily: _kanit),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          RaisedButton(
            child: Text('test'),
            onPressed: () {
              _getNotiList();
            },
          ),
        ],
      ),
    );
  }

  Widget cardNoti({
    leaveDate,
    noti,
    userid,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 20),
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.notifications,
                                  color: Colors.amber,
                                ),
                                Text(
                                  noti.substring(0, 36).toString(),
                                  style: TextStyle(
                                    fontFamily: _kanit,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            // Text(
                            //   'ชื่อ : $userid',
                            //   style: TextStyle(
                            //     fontFamily: _kanit,
                            //     fontSize: 13.0,
                            //   ),
                            // ),
                            Text(
                              'วันที่ : $leaveDate',
                              style: TextStyle(
                                fontFamily: _kanit,
                                fontSize: 13.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
