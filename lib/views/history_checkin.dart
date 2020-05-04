import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workcheckin/models/checkin_history.dart';
import 'package:workcheckin/models/size_config.dart';

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
      userID = msg['cwiUser']['modelid'];
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

    if (msg['checkinModelList'].toString() == '[]') {
      return null;
    } else {
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
            n['lateFlag'],
            n['earlyTime'],
            n['earlyFlag'],
            n['createDate'],
            n['createTime'],
            n['createBy'],
            n['checkoutDate'],
            n['checkoutTime']);
        checkinHsitories.add(checkinHistory);
      }

      return checkinHsitories;
    }
  }

  @override
  void initState() {
    super.initState();
    getMsg();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var sizeHor = SizeConfig.safeBlockHorizontal;
    var sizeVer = SizeConfig.safeBlockVertical;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'ประวัติลงเวลา',
            style: TextStyle(fontFamily: _kanit),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/images/bg.jpg',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            FutureBuilder(
              future: _getLeave(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return Container();
                } else {
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    padding:
                        EdgeInsets.only(top: sizeVer * 2, bottom: sizeVer * 2),
                    child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return cardNoti(
                          checkinDate:
                              snapshot.data[index].createDate.toString(),
                          checinTime:
                              snapshot.data[index].createTime.toString(),
                          checkoutDate:
                              snapshot.data[index].checkoutDate.toString(),
                          checkoutTime: snapshot.data[index].checkoutTime
                                      .toString() ==
                                  'null'
                              ? '-'
                              : snapshot.data[index].checkoutTime.toString(),
                          lateFlag: snapshot.data[index].lateFlag.toString(),
                          earlyFlag: snapshot.data[index].earlyFlag.toString(),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget cardNoti({
    checkinDate,
    checinTime,
    checkoutDate,
    checkoutTime,
    lateFlag,
    earlyFlag,
  }) {
    SizeConfig().init(context);
    var sizeHor = SizeConfig.safeBlockHorizontal;
    var sizeVer = SizeConfig.safeBlockVertical;
    var scrSize = MediaQuery.of(context).size;

    TextStyle styleLate = TextStyle(
      fontFamily: _kanit,
      color: Colors.red,
      fontSize: scrSize.width / 23,
    );
    TextStyle styleNoLate = TextStyle(
      fontFamily: _kanit,
      color: Colors.green,
      fontSize: scrSize.width / 23,
    );
    TextStyle styleNoLateTitle = TextStyle(
      fontFamily: _kanit,
      color: Colors.green,
      fontSize: scrSize.width / 30,
    );

    return Padding(
      padding: EdgeInsets.only(
          left: sizeHor * 5, right: sizeHor * 5, bottom: sizeVer * 0.2),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 5.0,
        child: Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 20),
          child: Container(
            width: sizeHor * 30,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                        left: sizeHor * 1.2,
                      ),
                      child: Container(
                        width: sizeHor * 85,
                        child: Column(
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
                                      child: Text(
                                        'เข้า',
                                        textAlign: TextAlign.center,
                                        style: lateFlag == '1'
                                            ? styleNoLateTitle
                                            : styleNoLateTitle,
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        'ออก',
                                        textAlign: TextAlign.center,
                                        style: lateFlag == '1'
                                            ? styleNoLateTitle
                                            : styleNoLateTitle,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Table(
                              columnWidths: {
                                0: FlexColumnWidth(4.0),
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
                                        style: lateFlag == '1'
                                            ? styleNoLate
                                            : styleNoLate,
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        '$checinTime',
                                        textAlign: TextAlign.center,
                                        style: lateFlag == '1'
                                            ? styleLate
                                            : lateFlag == 'null'
                                                ? styleLate
                                                : styleNoLate,
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        '$checkoutTime',
                                        textAlign: TextAlign.center,
                                        style: earlyFlag == '1'
                                            ? styleLate
                                            : earlyFlag == 'null'
                                                ? styleLate
                                                : styleNoLate,
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
