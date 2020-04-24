import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:workcheckin/models/boss_leave_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final _kanit = 'Kanit';

class BossScreen extends StatefulWidget {
  @override
  _BossScreenState createState() => _BossScreenState();
}

class _BossScreenState extends State<BossScreen> {
  var bossID;
  SharedPreferences sharedPreferences;
  bool visible = false;
  var msg;

  getMsg() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var msg = jsonDecode(sharedPreferences.getString('userMsg'));
    setState(() {
      bossID = msg['cwiUser']['bossId'];
    });
  }

  Future<List<BossLeaveModel>> _getLeave() async {
    var data = {"bossId": bossID};
    print(bossID);

    var url = 'http://159.138.232.139/service/cwi/v1/user/request_leave_list_by_boss';

    var response = await http.post(
      url,
      body: json.encode(data),
      headers: {"Authorization": "Basic bWluZGFvbm91YjpidTBuMEByQGRyZWU=", "Content-Type": "application/json"},
    );

    Map<String, dynamic> msg = jsonDecode(response.body);

    print('msgbosslist: $msg');

    List<BossLeaveModel> leaveModels = [];

    for (var leave in msg['trnLeaveList']) {
      BossLeaveModel leaveModel = BossLeaveModel(
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
          title: Text('ใบลา(หัวหน้า)', style: TextStyle(fontFamily: _kanit)),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FutureBuilder(
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
                          return Container(
                            height: MediaQuery.of(context).size.height,
                            child: ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                return cardHistory(
                                  leaveDate: snapshot.data[index].leaveDate.toString().substring(0, 9),
                                  leaveHour: snapshot.data[index].leaveHour.toString(),
                                  remark: snapshot.data[index].remark.toString(),
                                  approveFlag: snapshot.data[index].approveFlag.toString() == 'null' ? 'รอการอนุมัติ' : '',
                                  approveRejectDate: snapshot.data[index].approveRejectDate.toString() == 'null' ? '' : '()',
                                  id: snapshot.data[index].modelid,
                                  userid: snapshot.data[index].userId.toString(),
                                  actionOk: () async {
                                    var leaveid = '';
                                    var userid = snapshot.data[index].userId.toString();
                                    var leavedate = snapshot.data[index].leaveDate.toString();
                                    var leavehour = snapshot.data[index].leaveHour.toString();
                                    var leavecode = snapshot.data[index].leaveHour.toString();
                                    var approveflag = snapshot.data[index].approveFlag.toString();
                                    var remark = snapshot.data[index].remark.toString();
                                    print(userid);
                                    var jsonData = {"leaveId": "", "userId": userid, "leaveDate": leavedate, "leaveHour": leavehour, "leaveCode": leavecode, "approveFlag": "1", "remark": remark};
                                    print('index: $index ok');
                                    print('userJson: ' + jsonEncode(jsonData));

                                    // check response
                                    var url = 'http://159.138.232.139/service/cwi/v1/user/request_leave';
                                    var response = await http.post(
                                      url,
                                      body: json.encode(jsonData),
                                      headers: {"Authorization": "Basic bWluZGFvbm91YjpidTBuMEByQGRyZWU=", "Content-Type": "application/json"},
                                    );

                                    Map<String, dynamic> message = jsonDecode(response.body);
                                    setState(() {
                                      msg = message;
                                    });

                                    print('res: $message');

                                    if (message['responseCode'] == '000') {
                                      // Success
                                      setState(() {
                                        visible = false;
                                      });
                                      Alert(context: context, type: AlertType.success, title: "ยืนยันการลาสำเร็จ", desc: "", buttons: [
                                        DialogButton(
                                          child: Text(
                                            "ตกลง",
                                            style: TextStyle(fontFamily: _kanit, color: Colors.white, fontSize: 20),
                                          ),
                                          onPressed: () => Navigator.pop(context),
                                          color: Colors.green,
                                        ),
                                      ]).show();
                                    } else {
                                      // Failed to process
                                      var msgDesc;
                                      setState(() {
                                        visible = false;
                                        msgDesc = msg['responseDesc'];
                                      });
                                      Alert(
                                        context: context,
                                        type: AlertType.warning,
                                        title: msgDesc,
                                        desc: "",
                                        buttons: [
                                          DialogButton(
                                            child: Text(
                                              "ตกลง",
                                              style: TextStyle(fontFamily: _kanit, color: Colors.white, fontSize: 20),
                                            ),
                                            onPressed: () => Navigator.pop(context),
                                            color: Colors.red,
                                          )
                                        ],
                                      ).show();
                                    }
                                  },
                                  actionNo: () async {
                                    var leaveid = '';
                                    var userid = snapshot.data[index].userId.toString();
                                    var leavedate = snapshot.data[index].leaveDate.toString();
                                    var leavehour = snapshot.data[index].leaveHour.toString();
                                    var leavecode = snapshot.data[index].leaveHour.toString();
                                    var approveflag = snapshot.data[index].approveFlag.toString();
                                    var remark = snapshot.data[index].remark.toString();

                                    var jsonData = {"leaveId": "", "userId": userid, "leaveDate": leavedate, "leaveHour": leavehour, "leaveCode": leavecode, "approveFlag": "2", "remark": remark};
                                    print('index: $index failed');
                                    print('userJson: ' + jsonEncode(jsonData));

                                    // check response
                                    var url = 'http://159.138.232.139/service/cwi/v1/user/request_leave';
                                    var response = await http.post(
                                      url,
                                      body: json.encode(jsonData),
                                      headers: {"Authorization": "Basic bWluZGFvbm91YjpidTBuMEByQGRyZWU=", "Content-Type": "application/json"},
                                    );

                                    Map<String, dynamic> message = jsonDecode(response.body);

                                    print('res: $message');

                                    if (message['responseCode'] == '000') {
                                      // Success
                                      setState(() {
                                        visible = false;
                                      });
                                      Alert(context: context, type: AlertType.success, title: "ยกเลิกใบลาสำเร็จ", desc: "", buttons: [
                                        DialogButton(
                                          child: Text(
                                            "ตกลง",
                                            style: TextStyle(fontFamily: _kanit, color: Colors.white, fontSize: 20),
                                          ),
                                          onPressed: () => Navigator.pop(context),
                                          color: Colors.green,
                                        ),
                                      ]).show();
                                    } else {
                                      // Failed to process

                                      var msgDesc;
                                      setState(() {
                                        visible = false;
                                        msgDesc = msg['responseDesc'];
                                      });
                                      Alert(
                                        context: context,
                                        type: AlertType.warning,
                                        title: msgDesc,
                                        desc: "",
                                        buttons: [
                                          DialogButton(
                                            child: Text(
                                              "ตกลง",
                                              style: TextStyle(fontFamily: _kanit, color: Colors.white, fontSize: 20),
                                            ),
                                            onPressed: () => Navigator.pop(context),
                                            color: Colors.red,
                                          )
                                        ],
                                      ).show();
                                    }
                                  },
                                );
                              },
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
                Center(
                  child: Visibility(
                    visible: visible,
                    child: CircularProgressIndicator(),
                  ),
                ),
              ],
            ),
          ),
        ),
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
    userid,
    Function actionOk,
    Function actionNo,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 20),
          child: Row(
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
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4, right: 8),
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                      child: RawMaterialButton(
                        onPressed: actionOk,
                        child: Icon(
                          FontAwesomeIcons.check,
                          color: Colors.white,
                          size: 20.0,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4, right: 14),
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                      child: RawMaterialButton(
                        onPressed: actionNo,
                        child: Icon(
                          FontAwesomeIcons.times,
                          size: 20.0,
                          color: Colors.white,
                        ),
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
