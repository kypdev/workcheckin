import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:workcheckin/models/notification_model.dart';
import 'package:workcheckin/models/size_config.dart';

final _kanit = 'Kanit';

class NotiBossScreen extends StatefulWidget {
  @override
  _NotiBossScreenState createState() => _NotiBossScreenState();
}

class _NotiBossScreenState extends State<NotiBossScreen> {
  SharedPreferences sharedPreferences;

  Future<List<BossNotifyModel>> _getNotiList() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var msg = jsonDecode(sharedPreferences.getString('userMsg'));
    var branchid = msg['cwiUser']['branchId'].toString();

    var url = 'http://159.138.232.139/service/cwi/v1/user/get_noti_list';
    var data = {"branchId": branchid};

    var response = await http.post(
      url,
      body: json.encode(data),
      headers: {
        "Authorization": "Basic bWluZGFvbm91YjpidTBuMEByQGRyZWU=",
        "Content-Type": "application/json"
      },
    );

    Map<String, dynamic> message = jsonDecode(response.body);

    List<BossNotifyModel> bossNotiList = [];

    if (message['trnNotiModelList'].toString() == '[]') {
      return null;
    } else {
      for (var n in message['trnNotiModelList']) {
        BossNotifyModel bossNotify = BossNotifyModel(
          n['modelid'],
          n['userId'],
          n['name'],
          n['bossId'],
          n['noti'],
          n['createDate'],
          n['createBy'],
        );
        bossNotiList.add(bossNotify);
      }
      return bossNotiList;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var sizeHor = SizeConfig.safeBlockHorizontal;
    var sizeVer = SizeConfig.safeBlockVertical;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'แจ้งเตือน',
          style: TextStyle(
            fontFamily: _kanit,
          ),
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
              future: _getNotiList(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return Container();
                } else {
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: sizeVer * 0.59),
                    child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: <Widget>[
                            cardNoti(
                              leaveDate:
                                  snapshot.data[index].createDate.toString(),
                              noti: snapshot.data[index].noti.toString(),
                              userid: snapshot.data[index].name.toString(),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                }
              }),
        ],
      ),
    );
  }

  Widget cardNoti({
    leaveDate,
    noti,
    userid,
  }) {
    SizeConfig().init(context);
    var sizeHor = SizeConfig.safeBlockHorizontal;
    var sizeVer = SizeConfig.safeBlockVertical;

    return Column(
      children: <Widget>[
        Container(
          width: 20,
          height: sizeVer * 0.9,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: sizeHor * 5),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            elevation: 5,
            child: Padding(
              padding: EdgeInsets.only(
                  left: sizeHor * 2, top: sizeVer * 4, bottom: sizeVer * 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: sizeHor * 2),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Icon(
                                  Icons.notifications,
                                  color: Colors.amber,
                                  size: sizeHor * 7,
                                ),
                                Container(
                                  width: sizeHor * 70,
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        '$noti',
                                        style: TextStyle(
                                          fontFamily: _kanit,
                                          fontSize: sizeHor * 3.8,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: sizeVer * 2),
                          Padding(
                            padding: EdgeInsets.only(left: sizeHor * 4),
                            child: Text(
                              'ชื่อ : $userid',
                              style: TextStyle(
                                fontFamily: _kanit,
                                fontSize: sizeHor * 3.1,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: sizeHor * 4),
                            child: Text(
                              'วันที่ : $leaveDate',
                              style: TextStyle(
                                fontFamily: _kanit,
                                fontSize: sizeHor * 3.1,
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
        ),
      ],
    );
  }
}
