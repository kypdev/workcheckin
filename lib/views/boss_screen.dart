import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workcheckin/models/request_by_boss.dart';

final _kanit = 'Kanit';

class BossScreen extends StatefulWidget {
  @override
  _BossScreenState createState() => _BossScreenState();
}

class _BossScreenState extends State<BossScreen> {
  //  bossid = account userid
  var bossID;
  SharedPreferences sharedPreferences;
  bool visible = false;

  getMsg() async {}

  @override
  void initState() {
    super.initState();
  }

  Future<List<RequestByBoss>> _getLeaveHenchList() async {
    var url = 'http://159.138.232.139/service/cwi/v1/user/request_leave_list_by_boss';
    sharedPreferences = await SharedPreferences.getInstance();
    var msg = jsonDecode(sharedPreferences.getString('userMsg'));
    var bossID = msg['cwiUser']['modelid'];
    print(bossID);
    var data = {"bossId": bossID};
    var response = await http.post(
      url,
      body: json.encode(data),
      headers: {"Authorization": "Basic bWluZGFvbm91YjpidTBuMEByQGRyZWU=", "Content-Type": "application/json"},
    );
    Map<String, dynamic> message = jsonDecode(response.body);
    print(message['trnLeaveList']);
    List<RequestByBoss> hencLeaveList = [];
    for (var n in message['trnLeaveList']) {
      RequestByBoss requestByBoss = RequestByBoss(n['modelid'], n['userId'], n['leaveTypeCode'], n['leaveDate'], n['leaveHour'], n['remark'], n['approveFlag'], n['approveRejectDate'], n['approveRejectBy'], n['createDate'], n['createBy'], n['updateDate'], n['updateBy']);
      hencLeaveList.add(requestByBoss);
    }
    return hencLeaveList;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('ใบลา(หัวหน้า)', style: TextStyle(fontFamily: _kanit)),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FutureBuilder(
                      future: _getLeaveHenchList(),
                      builder: (BuildContext context, AsyncSnapshot sn) {
                        if (sn.data == null) {
                          return Column(
                            children: <Widget>[
                              Center(
                                child: Visibility(visible: true, child: CircularProgressIndicator()),
                              ),
                              SizedBox(height: 20),
                              Text(
                                'ไม่พบข้อมูล',
                                style: TextStyle(
                                  fontFamily: _kanit,
                                  fontSize: 18,
                                ),
                              )
                            ],
                          );
                        } else {
                          return Container(
                            height: MediaQuery.of(context).size.height,
                            child: ListView.builder(
                              itemCount: sn.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                return cardHistory(
                                  leaveDate: sn.data[index].leaveDate.toString(),
                                  userid: sn.data[index].userId.toString(),
                                  leaveHour: sn.data[index].leaveHour.toString(),
                                  approveFlag: sn.data[index].approveFlag.toString(),
                                  approveRejectDate: sn.data[index].approveRejectDate.toString(),
                                  remark: sn.data[index].remark.toString(),
                                  id: sn.data[index].modelid.toString(),
                                  actionOk: () {
                                    print(
                                      sn.data[index].approveFlag.toString(),
                                    );
                                    setState(() => visible = true);
                                    Alert(
                                      context: context,
                                      type: AlertType.warning,
                                      title: "คุณแน่ใจว่าจะยืนยันใบลานี้ ?",
                                      desc: "",
                                      buttons: [
                                        DialogButton(
                                          child: Text(
                                            "ใช่",
                                            style: TextStyle(fontFamily: _kanit, color: Colors.white, fontSize: 20),
                                          ),
                                          onPressed: () async {
                                            // start process approve
                                            var leaveid = sn.data[index].modelid.toString();
                                            var data = {"leaveId": leaveid, "userId": bossID, "approveFlag": "1"};
                                            var url = 'http://159.138.232.139/service/cwi/v1/user/request_leave_approve';
                                            var response = await http.post(
                                              url,
                                              body: json.encode(data),
                                              headers: {"Authorization": "Basic bWluZGFvbm91YjpidTBuMEByQGRyZWU=", "Content-Type": "application/json"},
                                            );

                                            Map<String, dynamic> message = jsonDecode(response.body);

                                            if (message['responseCode'] == '000') {
                                              // success
                                              setState(() => visible = false);
                                              Navigator.pop(context);
                                              Alert(context: context, type: AlertType.success, title: 'ยืนยันใบลาสำเร็จ', desc: "", buttons: [
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
                                              Navigator.pop(context);
                                              setState(() {
                                                visible = false;
                                              });
                                              Alert(
                                                context: context,
                                                type: AlertType.warning,
                                                title: message['responseDesc'].toString(),
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

                                            // end process leave
                                          },
                                          color: Color.fromRGBO(0, 179, 134, 1.0),
                                        ),
                                        DialogButton(
                                          child: Text(
                                            "ไม่ใช่",
                                            style: TextStyle(fontFamily: _kanit, color: Colors.white, fontSize: 20),
                                          ),
                                          onPressed: () {
                                            setState(() => visible = false);
                                            Navigator.pop(context);
                                          },
                                          gradient: LinearGradient(colors: [Color.fromRGBO(116, 116, 191, 1.0), Color.fromRGBO(52, 138, 199, 1.0)]),
                                        )
                                      ],
                                    ).show();
                                  },
                                  actionNo: () {
                                    setState(() => visible = true);
                                    Alert(
                                      context: context,
                                      type: AlertType.warning,
                                      title: "คุณแน่ใจว่าจะยกเลิกใบลานี้ ?",
                                      desc: "",
                                      buttons: [
                                        DialogButton(
                                          child: Text(
                                            "ใช่",
                                            style: TextStyle(fontFamily: _kanit, color: Colors.white, fontSize: 20),
                                          ),
                                          onPressed: () async {
                                            // start process reject
                                            var leaveid = sn.data[index].modelid.toString();
                                            var data = {"leaveId": leaveid, "userId": bossID, "approveFlag": "2"};
                                            var url = 'http://159.138.232.139/service/cwi/v1/user/request_leave_approve';
                                            var response = await http.post(
                                              url,
                                              body: json.encode(data),
                                              headers: {"Authorization": "Basic bWluZGFvbm91YjpidTBuMEByQGRyZWU=", "Content-Type": "application/json"},
                                            );

                                            Map<String, dynamic> message = jsonDecode(response.body);

                                            if (message['responseCode'] == '000') {
                                              // success
                                              setState(() => visible = false);
                                              Navigator.pop(context);
                                              Alert(context: context, type: AlertType.success, title: 'ยกเลิกใบลาสำเร็จ', desc: "", buttons: [
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
                                              Navigator.pop(context);
                                              setState(() {
                                                visible = false;
                                              });
                                              Alert(
                                                context: context,
                                                type: AlertType.warning,
                                                title: message['responseDesc'].toString(),
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

                                            // end process leave
                                          },
                                          color: Color.fromRGBO(0, 179, 134, 1.0),
                                        ),
                                        DialogButton(
                                          child: Text(
                                            "ไม่ใช่",
                                            style: TextStyle(fontFamily: _kanit, color: Colors.white, fontSize: 20),
                                          ),
                                          onPressed: () {
                                            setState(() => visible = false);
                                            Navigator.pop(context);
                                          },
                                          gradient: LinearGradient(colors: [Color.fromRGBO(116, 116, 191, 1.0), Color.fromRGBO(52, 138, 199, 1.0)]),
                                        )
                                      ],
                                    ).show();
                                  },
                                );
                              },
                            ),
                          );
                        }
                      },
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 1,
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
                    Row(
                      children: <Widget>[
                        Text(
                          'สถานะการลา : ',
                          style: TextStyle(
                            fontFamily: _kanit,
                            fontSize: 13.0,
                          ),
                        ),
                        Text(
                          approveFlag == '1' ? 'อนุมัติแล้ว' : approveFlag == '2' ? 'ยกเลิกแล้ว' : 'รอการอนุมัติ',
                          style: TextStyle(
                            fontFamily: _kanit,
                            fontSize: 13.0,
                          ),
                        ),
                      ],
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
