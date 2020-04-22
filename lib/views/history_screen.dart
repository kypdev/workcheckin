import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  Map<String, dynamic> message;
  var userID;

  getMsg() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var msg = jsonDecode(sharedPreferences.getString('userMsg'));
    setState(() {
      userID = msg['cwiUser']['modelid'];
    });
  }

  Future<List<LeaveModel>> _getLeave() async {
    var data = {"bossId": "", "userId": userID, "leaveDate": "19/04/2020", "leaveCode": ""};

    var url = 'http://159.138.232.139/service/cwi/v1/user/request_leave_list_by_user';

    var response = await http.post(
      url,
      body: json.encode(data),
      headers: {"Authorization": "Basic bWluZGFvbm91YjpidTBuMEByQGRyZWU=", "Content-Type": "application/json"},
    );

    Map<String, dynamic> msg = jsonDecode(response.body);

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
    return leaveModels;
  }

  getdata() async {
    var data = {"bossId": "", "userId": userID, "leaveDate": "19/04/2020", "leaveCode": ""};

    var url = 'http://159.138.232.139/service/cwi/v1/user/request_leave_list_by_user';

    var response = await http.post(
      url,
      body: json.encode(data),
      headers: {"Authorization": "Basic bWluZGFvbm91YjpidTBuMEByQGRyZWU=", "Content-Type": "application/json"},
    );

    Map<String, dynamic> msg = jsonDecode(response.body);

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
  }

  @override
  void initState() {
    super.initState();
    getMsg();
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
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(),
              FutureBuilder(
                future: _getLeave(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.data != null) {
                    return Container(
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Card(
                              elevation: 5.0,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Container(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'วันที่ลา : ' + snapshot.data[index].leaveDate.toString(),
                                            style: TextStyle(
                                              fontFamily: _kanit,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                          SizedBox(height: 10.0),
                                          Text(
                                            'ชั่วโมง : ' + snapshot.data[index].leaveHour.toString(),
                                            style: TextStyle(
                                              fontFamily: _kanit,
                                              fontSize: 13.0,
                                            ),
                                          ),
                                          Text(
                                            'ชั่วโมง : ' + snapshot.data[index].leaveHour.toString(),
                                            style: TextStyle(
                                              fontFamily: _kanit,
                                              fontSize: 13.0,
                                            ),
                                          ),
                                          Text(
                                            snapshot.data[index].approveFlag.toString() == 'null' ? 'สถานะการลา รอการอนุมัติ' : '',
                                            style: TextStyle(
                                              fontFamily: _kanit,
                                              fontSize: 13.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: RawMaterialButton(
                                        padding: EdgeInsets.all(10),
                                        shape: CircleBorder(
                                          side: BorderSide(color: Colors.transparent),
                                        ),
                                        fillColor: Colors.blue,
                                        onPressed: () async {
                                          var userID = snapshot.data[index].userId.toString();
                                          var leaveDate = snapshot.data[index].leaveDate.toString();
                                          var leaveHour = snapshot.data[index].leaveHour.toString();
                                          var leaveTypeCode = snapshot.data[index].leaveTypeCode.toString();
                                          var approveFlag = "9";
                                          var remark = snapshot.data[index].remark.toString();
                                          var url = 'http://159.138.232.139/service/cwi/v1/user/login';

                                          var jsonData = {"leaveId": "", "userId": userID, "leaveDate": leaveDate, "leaveHour": leaveHour, "leaveCode": leaveTypeCode, "approveFlag": approveFlag, "remark": remark};

                                          print('jsonData: ' + jsonEncode(jsonData));

                                          var response = await http.post(
                                            url,
                                            body: json.encode(jsonData),
                                            headers: {"Authorization": "Basic bWluZGFvbm91YjpidTBuMEByQGRyZWU=", "Content-Type": "application/json"},
                                          );
                                        },
                                        child: Icon(
                                          FontAwesomeIcons.trashAlt,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return Center(
                      child: Visibility(
                        visible: true,
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
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
                  style: TextStyle(fontSize: 18, fontFamily: _kanit, color: Colors.black54),
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
