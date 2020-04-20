import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workcheckin/models/checkin_history.dart';

final _kanit = 'Kanit';

class HistoryCheckin extends StatefulWidget {
  @override
  _HistoryCheckinState createState() => _HistoryCheckinState();
}

class _HistoryCheckinState extends State<HistoryCheckin> {
  SharedPreferences sharedPreferences;
  var userID;
  getMsg() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var msg = jsonDecode(sharedPreferences.getString('userMsg'));
    setState(() {
      userID= msg['cwiUser']['modelid'];
    });
  }

  Future<List<CheckinHistory>> _getLeave() async {
    var data = {"userId": userID};

    var url = 'http://159.138.232.139/service/cwi/v1/user/history_checkin';

    var response = await http.post(
      url,
      body: json.encode(data),
      headers: {
        "Authorization": "Basic bWluZGFvbm91YjpidTBuMEByQGRyZWU=",
        "Content-Type": "application/json"
      },
    );

    Map<String, dynamic> msg = jsonDecode(response.body);

    List<CheckinHistory> checkinHsitories = [];

    for (var n in msg['checkinModelList']) {
      CheckinHistory checkinHistory = CheckinHistory(
        n['modelid'],
        n['userId'],
        n['deviceId'],
        n['osMobile'],
        n['locationId'],
        n['bossId'],
        n['actionCode'],
        n['locationName'],
        n['platform'],
        n['lateTime'],
        n['createDate'],
        n['createTime'],
        n['createBy'],
        n['checkoutDate'],
        n['checkoutTime'],
      );
      checkinHsitories.add(checkinHistory);
    }

    return checkinHsitories;
  }

  @override
  void initState() {
    super.initState();
    getMsg();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ประวัติลงเวลา',
          style: TextStyle(fontFamily: _kanit),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _getLeave(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Text('loading...');
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return cardNoti(
                  checkinDate: snapshot.data[index].createDate.toString(),
                  checinTime: snapshot.data[index].createTime.toString(),
                  checkoutDate: snapshot.data[index].checkoutDate.toString(),
                  checkoutTime:
                      snapshot.data[index].checkoutTime.toString() == 'null'
                          ? '-'
                          : snapshot.data[index].checkoutTime.toString(),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget cardNoti({
    checkinDate,
    checinTime,
    checkoutDate,
    checkoutTime,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 20),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
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
                            Table(
                              columnWidths: {
                                0: FlexColumnWidth(4.0),
                                1: FlexColumnWidth(3.0),
                                2: FlexColumnWidth(3.0),
                              },
                              children: [
                                TableRow(
                                  children: [
                                    Container(),
                                    Container(
                                      child: Text('เข้า',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: _kanit,
                                              color: Colors.green,
                                              fontSize: 12.0)),
                                    ),
                                    Container(
                                      child: Text('ออก',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: _kanit,
                                              color: Colors.red,
                                              fontSize: 12.0)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Table(
                              columnWidths: {
                                0: FlexColumnWidth(3.0),
                                1: FlexColumnWidth(3.0),
                                2: FlexColumnWidth(3.0),
                              },
                              children: [
                                TableRow(
                                  children: [
                                    Container(
                                      child: Text(
                                        '$checkinDate',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: _kanit,
                                          color: Colors.green,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        '$checinTime',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: _kanit,
                                          color: Colors.green,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        '$checkoutTime',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: _kanit,
                                          color: Colors.red,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
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
