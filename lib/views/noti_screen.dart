import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:workcheckin/models/notification_model.dart';

final _kanit = 'Kanit';

class NotiScreen extends StatefulWidget {
  @override
  _NotiScreenState createState() => _NotiScreenState();
}

class _NotiScreenState extends State<NotiScreen> {
  Future<List<NotificationModel>> _getLeave() async {
    var data = {
      "bossId": "",
      "userId": "15",
      "leaveDate": "19/04/2020",
      "leaveCode": ""
    };

    var url = 'http://159.138.232.139/service/cwi/v1/user/get_noti_list';

    var response = await http.post(
      url,
      body: json.encode(data),
      headers: {
        "Authorization": "Basic bWluZGFvbm91YjpidTBuMEByQGRyZWU=",
        "Content-Type": "application/json"
      },
    );

    Map<String, dynamic> msg = jsonDecode(response.body);
    

    List<NotificationModel> noti = [];

    for (var n in msg['trnNotiModelList']) {
      NotificationModel notificationModel = NotificationModel(
        n['modelid'],
        n['userId'],
        n['bossId'],
        n['noti'],
        n['createDate'],
        n['createBy'],
      );
      noti.add(notificationModel);
    }
    
    return noti;
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
                    leaveDate: snapshot.data[index].createDate.toString(),
                    noti: snapshot.data[index].createDate.toString(),
                    userid: snapshot.data[index].userId.toString());
              },
            );
          }
        },
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
                        Text(
                          'วันที่ลา : $leaveDate',
                          style: TextStyle(
                            fontFamily: _kanit,
                            fontSize: 16.0,
                          ),
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
                          'แจ้งเตือน : $noti',
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
