import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:workcheckin/models/leave_model.dart';

final _kanit = 'Kanit';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  var employee = 'พนักงาน';
  SharedPreferences sharedPreferences;
  var message;

  getMsg() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var msg = jsonDecode(sharedPreferences.getString('userMsg'));
    setState(() {
      message = msg;
    });
  }

  Future<List<LeaveModel>> _getLeave() async {
    var data = {
      "bossId": "",
      "userId": "15",
      "leaveDate": "19/04/2020",
      "leaveCode": ""
    };

    var url =
        'http://159.138.232.139/service/cwi/v1/user/request_leave_list_by_user';

    var response = await http.post(
      url,
      body: json.encode(data),
      headers: {
        "Authorization": "Basic bWluZGFvbm91YjpidTBuMEByQGRyZWU=",
        "Content-Type": "application/json"
      },
    );

    Map<String, dynamic> msg = jsonDecode(response.body);
    print(msg['trnLeaveList'][0]['modelid']);

    List<LeaveModel> leaveModels = [];

    for (var leave in msg['trnLeaveList']) {
      LeaveModel leaveModel = LeaveModel(
        leave['modelid'],
        leave['userId'],
        leave['leaveTypeCode'],
        leave['leaveDate'],
        leave['leaveHour'],
        leave['remark'],
        leave['approveFlag'],
        leave['approveRejectDate'],
        leave['approveRejectBy'],
        leave['createDate'],
        leave['createBy'],
        leave['updateDate'],
        leave['updateBy'],
      );
      leaveModels.add(leaveModel);
    }
    print(msg['trnLeaveList']);
    return leaveModels;
  }

  getdata() async {
    var userID = message['cwiUser']['modelid'];
    var data = {
      "bossId": "",
      "userId": userID,
      "leaveDate": "19/04/2020",
      "leaveCode": ""
    };

    var url =
        'http://159.138.232.139/service/cwi/v1/user/request_leave_list_by_user';

    var response = await http.post(
      url,
      body: json.encode(data),
      headers: {
        "Authorization": "Basic bWluZGFvbm91YjpidTBuMEByQGRyZWU=",
        "Content-Type": "application/json"
      },
    );

    Map<String, dynamic> msg = jsonDecode(response.body);
    print(msg['trnLeaveList'][0]['modelid']);

    List<LeaveModel> leaveModels = [];

    for (var leave in msg['trnLeaveList']) {
      LeaveModel leaveModel = LeaveModel(
        leave['modelid'],
        leave['userId'],
        leave['leaveTypeCode'],
        leave['leaveDate'],
        leave['leaveHour'],
        leave['remark'],
        leave['approveFlag'],
        leave['approveRejectDate'],
        leave['approveRejectBy'],
        leave['createDate'],
        leave['createBy'],
        leave['updateDate'],
        leave['updateBy'],
      );

      leaveModels.add(leaveModel);
    }
    print(msg['trnLeaveList']);
  }

  @override
  void initState() {
    getMsg();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'ประวัติการลา',
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
              return Center(
                child: Visibility(
                  visible: true,
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return cardHistory(
                    leaveDate: snapshot.data[index].leaveDate
                        .toString()
                        .substring(0, 9),
                    leaveHour: snapshot.data[index].leaveHour.toString(),
                    remark: snapshot.data[index].remark.toString(),
                    approveFlag:
                        snapshot.data[index].approveFlag.toString() == 'null'
                            ? 'รอการอนุมัติ'
                            : '',
                    approveRejectDate:
                        snapshot.data[index].approveRejectDate.toString() ==
                                'null'
                            ? ''
                            : '()',
                    id: snapshot.data[index].modelid,
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  Widget getEmpolyee({
    title,
    employee,
    action,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontFamily: _kanit,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  employee,
                  style: TextStyle(
                      fontSize: 18, fontFamily: _kanit, color: Colors.black54),
                ),
                IconButton(
                  onPressed: action,
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black54,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget cardHistory({
    leaveDate,
    leaveHour,
    remark,
    approveFlag,
    approveRejectDate,
    id,
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
                          'ชั่วโมง : $leaveHour',
                          style: TextStyle(
                            fontFamily: _kanit,
                            fontSize: 13.0,
                          ),
                        ),
                        Text(
                          'สถานะการลา : $approveFlag$approveRejectDate',
                          style: TextStyle(
                            fontFamily: _kanit,
                            fontSize: 13.0,
                          ),
                        ),
                        Text(
                          'เหตุผล : $remark',
                          style: TextStyle(
                            fontFamily: _kanit,
                            fontSize: 13.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4, right: 20),
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
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
