import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:workcheckin/models/notification_model.dart';

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
      headers: {"Authorization": "Basic bWluZGFvbm91YjpidTBuMEByQGRyZWU=", "Content-Type": "application/json"},
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'แจ้งเตือน(หัวหน้า)',
          style: TextStyle(
            fontFamily: _kanit,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          FutureBuilder(
              future: _getNotiList(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Visibility(
                          visible: true,
                          child: CircularProgressIndicator(),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'ไม่พบข้อมูล...',
                          style: TextStyle(
                            fontFamily: _kanit,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Container(
                    child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return cardNoti(
                          leaveDate: snapshot.data[index].createDate.toString(),
                          noti: snapshot.data[index].noti.toString(),
                          userid: snapshot.data[index].name.toString(),
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
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 20),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Icon(
                              Icons.notifications,
                              color: Colors.amber,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    '$noti',
                                    style: TextStyle(
                                      fontFamily: _kanit,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          'ชื่อ : $userid',
                          style: TextStyle(
                            fontFamily: _kanit,
                            fontSize: 13.0,
                          ),
                        ),
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
