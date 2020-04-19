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
  var message;
  SharedPreferences sharedPreferences;
  getMsg() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var msg = jsonDecode(sharedPreferences.getString('userMsg'));
    setState(() {
      message = msg;
    });
  }
  Future<List<NotificationModel>> _getLeave() async {
    var userID = message['cwiUser']['modelid'];
    var data = {
      "bossId": "",
      "userId": userID,
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
  void initState() {
    getMsg();
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
                    noti: snapshot.data[index].noti.toString(),
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
                    child: Container(
                      width: MediaQuery.of(context).size.width*0.8,
                      child: Column(
                        
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(Icons.notifications, color: Colors.amber,),
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
