import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workcheckin/models/request_by_boss.dart';
import 'package:workcheckin/models/size_config.dart';

final _kanit = 'Kanit';

class BossScreen extends StatefulWidget {
  @override
  _BossScreenState createState() => _BossScreenState();
}

class _BossScreenState extends State<BossScreen> {
  var bossID;
  SharedPreferences sharedPreferences;
  bool visible = false;

  @override
  void initState() {
    super.initState();
  }

  Future<List<RequestByBoss>> _getLeaveHenchList() async {
    var url =
        'http://159.138.232.139/service/cwi/v1/user/request_leave_list_by_boss';
    sharedPreferences = await SharedPreferences.getInstance();
    var msg = jsonDecode(sharedPreferences.getString('userMsg'));
    var bossID = msg['cwiUser']['modelid'];
    var data = {"bossId": bossID};
    var response = await http.post(
      url,
      body: json.encode(data),
      headers: {
        "Authorization": "Basic bWluZGFvbm91YjpidTBuMEByQGRyZWU=",
        "Content-Type": "application/json"
      },
    );
    Map<String, dynamic> message = jsonDecode(response.body);
    if (message['trnLeaveList'].toString() == '[]') {
      return null;
    } else {
      List<RequestByBoss> hencLeaveList = [];
      for (var n in message['trnLeaveList']) {
        RequestByBoss requestByBoss = RequestByBoss(
            n['modelid'],
            n['userId'],
            n['leaveTypeCode'],
            n['leaveTypeName'],
            n['leaveDate'],
            n['leaveHour'],
            n['remark'],
            n['approveFlag'],
            n['approveRejectDate'],
            n['approveRejectBy'],
            n['createDate'],
            n['createBy'],
            n['updateDate'],
            n['updateBy']);
        hencLeaveList.add(requestByBoss);
      }
      return hencLeaveList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('รายงานการลา', style: TextStyle(fontFamily: _kanit)),
          centerTitle: true,
        ),
        body: Stack(
          alignment: Alignment.center,
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
              future: _getLeaveHenchList(),
              builder: (BuildContext context, AsyncSnapshot sn) {
                if (sn.data == null) {
                  return Container();
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
                          approveRejectDate:
                              sn.data[index].approveRejectDate.toString(),
                          remark: sn.data[index].remark.toString(),
                          id: sn.data[index].modelid.toString(),
                          leaveTypeName:
                              sn.data[index].leaveTypeName.toString(),
                          actionOk: () {
                            Alert(
                              context: context,
                              type: AlertType.warning,
                              title: "คุณแน่ใจว่าจะอนุมัติการลานี้?",
                              buttons: [
                                DialogButton(
                                  child: Text(
                                    "ใช่",
                                    style: TextStyle(
                                        fontFamily: _kanit,
                                        color: Colors.white,
                                        fontSize: 20),
                                  ),
                                  onPressed: () async {
                                    // start process approve
                                    setState(() => visible = true);
                                    var leaveid =
                                        sn.data[index].modelid.toString();
                                    var data = {
                                      "leaveId": leaveid,
                                      "userId": bossID,
                                      "approveFlag": "1"
                                    };
                                    var url =
                                        'http://159.138.232.139/service/cwi/v1/user/request_leave_approve';
                                    var response = await http.post(
                                      url,
                                      body: json.encode(data),
                                      headers: {
                                        "Authorization":
                                            "Basic bWluZGFvbm91YjpidTBuMEByQGRyZWU=",
                                        "Content-Type": "application/json"
                                      },
                                    );

                                    Map<String, dynamic> message =
                                        jsonDecode(response.body);

                                    if (message['responseCode'] == '000') {
                                      // success
                                      setState(() => visible = false);
                                      Navigator.pop(context);
                                      Alert(
                                          context: context,
                                          type: AlertType.success,
                                          title: 'ยืนยันใบลาสำเร็จ',
                                          desc: "",
                                          buttons: [
                                            DialogButton(
                                              child: Text(
                                                "ตกลง",
                                                style: TextStyle(
                                                    fontFamily: _kanit,
                                                    color: Colors.white,
                                                    fontSize: 20),
                                              ),
                                              onPressed: () =>
                                                  Navigator.pop(this.context),
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
                                        title:
                                            message['responseDesc'].toString(),
                                        desc: "",
                                        buttons: [
                                          DialogButton(
                                            child: Text(
                                              "ตกลง",
                                              style: TextStyle(
                                                  fontFamily: _kanit,
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ),
                                            onPressed: () =>
                                                Navigator.pop(context),
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
                                    style: TextStyle(
                                        fontFamily: _kanit,
                                        color: Colors.white,
                                        fontSize: 20),
                                  ),
                                  onPressed: () {
                                    setState(() => visible = false);
                                    Navigator.pop(context);
                                  },
                                  gradient: LinearGradient(colors: [
                                    Color.fromRGBO(116, 116, 191, 1.0),
                                    Color.fromRGBO(52, 138, 199, 1.0)
                                  ]),
                                )
                              ],
                            ).show();
                          },
                          actionNo: () {
                            Alert(
                              context: context,
                              type: AlertType.warning,
                              title: "คุณแน่ใจว่าจะไม่อนุมัติการลานี้?",
                              desc: "",
                              buttons: [
                                DialogButton(
                                  child: Text(
                                    "ใช่",
                                    style: TextStyle(
                                        fontFamily: _kanit,
                                        color: Colors.white,
                                        fontSize: 20),
                                  ),
                                  onPressed: () async {
                                    // start process reject
                                    var leaveid =
                                        sn.data[index].modelid.toString();
                                    var data = {
                                      "leaveId": leaveid,
                                      "userId": bossID,
                                      "approveFlag": "2"
                                    };
                                    var url =
                                        'http://159.138.232.139/service/cwi/v1/user/request_leave_approve';
                                    var response = await http.post(
                                      url,
                                      body: json.encode(data),
                                      headers: {
                                        "Authorization":
                                            "Basic bWluZGFvbm91YjpidTBuMEByQGRyZWU=",
                                        "Content-Type": "application/json"
                                      },
                                    );

                                    Map<String, dynamic> message =
                                        jsonDecode(response.body);

                                    if (message['responseCode'] == '000') {
                                      // success
                                      setState(() => visible = false);
                                      Navigator.pop(context);
                                      Alert(
                                          context: context,
                                          type: AlertType.success,
                                          title: 'บันทึกข้อมูลสำเร็จ',
                                          desc: "",
                                          buttons: [
                                            DialogButton(
                                              child: Text(
                                                "ตกลง",
                                                style: TextStyle(
                                                    fontFamily: _kanit,
                                                    color: Colors.white,
                                                    fontSize: 20),
                                              ),
                                              onPressed: () =>
                                                  Navigator.pop(this.context),
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
                                        title:
                                            message['responseDesc'].toString(),
                                        desc: "",
                                        buttons: [
                                          DialogButton(
                                            child: Text(
                                              "ตกลง",
                                              style: TextStyle(
                                                  fontFamily: _kanit,
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ),
                                            onPressed: () =>
                                                Navigator.pop(context),
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
                                    style: TextStyle(
                                        fontFamily: _kanit,
                                        color: Colors.white,
                                        fontSize: 20),
                                  ),
                                  onPressed: () {
                                    setState(() => visible = false);
                                    Navigator.pop(context);
                                  },
                                  gradient: LinearGradient(colors: [
                                    Color.fromRGBO(116, 116, 191, 1.0),
                                    Color.fromRGBO(52, 138, 199, 1.0)
                                  ]),
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
            Center(
              child: Visibility(
                visible: visible,
                child: CircularProgressIndicator(),
              ),
            ),
          ],
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
    leaveTypeName,
    Function actionOk,
    Function actionNo,
  }) {
    SizeConfig().init(context);
    var sizeHor = SizeConfig.safeBlockHorizontal;
    var sizeVer = SizeConfig.safeBlockVertical;
    var screenSize = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.only(
          left: sizeHor * 2, right: sizeHor * 2, top: sizeVer * 0.9),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 5.0,
        child: Padding(
          padding: EdgeInsets.only(
              top: sizeVer * 2,
              bottom: sizeVer * 2,
              right: sizeHor * 3,
              left: sizeHor * 3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: sizeHor * 3),
                child: Container(
                  width: sizeHor * 50,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'วันที่ลา : $leaveDate',
                        style: TextStyle(
                          fontFamily: _kanit,
                          fontSize: screenSize.width / 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'ประเภทการลา : $leaveTypeName',
                        style: TextStyle(
                          fontFamily: _kanit,
                          fontSize: screenSize.width / 24,
                        ),
                      ),
                      Text(
                        'ชื่อ : $userid',
                        style: TextStyle(
                          fontFamily: _kanit,
                          fontSize: screenSize.width / 24,
                        ),
                      ),
                      Text(
                        'ชั่วโมง : $leaveHour',
                        style: TextStyle(
                          fontFamily: _kanit,
                          fontSize: screenSize.width / 24,
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            'สถานะการลา : ',
                            style: TextStyle(
                              fontFamily: _kanit,
                              fontSize: screenSize.width / 24,
                            ),
                          ),
                          Text(
                            approveFlag == '1'
                                ? 'อนุมัติการลา'
                                : approveFlag == '2'
                                    ? 'ไม่อนุมัติการลา'
                                    : 'รอการอนุมัติ',
                            style: TextStyle(
                              fontFamily: _kanit,
                              fontSize: screenSize.width / 24,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'เหตุผล : $remark',
                        style: TextStyle(
                          fontFamily: _kanit,
                          fontSize: screenSize.width / 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: sizeHor * 2),
              Container(
                child: Row(
                  children: <Widget>[
                    InkWell(
                      onTap: actionOk,
                      child: Container(
                        width: screenSize.width / 8,
                        height: screenSize.height / 16,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue,
                        ),
                        child: Icon(
                          FontAwesomeIcons.check,
                          color: Colors.white,
                          size: screenSize.width / 13,
                        ),
                      ),
                    ),
                    SizedBox(width: screenSize.width / 50),
                    InkWell(
                      onTap: actionNo,
                      child: Container(
                        width: screenSize.width / 8,
                        height: screenSize.height / 16,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                        child: Icon(
                          FontAwesomeIcons.times,
                          color: Colors.white,
                          size: screenSize.width / 13,
                        ),
                      ),
                    ),

                    // Container(
                    //   color: Colors.amber,
                    //   child: RawMaterialButton(
                    //     fillColor: Colors.blue,
                    //     shape: CircleBorder(),
                    //     padding: EdgeInsets.all(sizeVer * 1.3),
                    //     onPressed: actionOk,
                    //     child: Icon(
                    //       FontAwesomeIcons.check,
                    //       color: Colors.white,
                    //       size: sizeHor * 6,
                    //     ),
                    //   ),
                    // ),

                    // SizedBox(width: sizeHor * 2),
                    // RawMaterialButton(
                    //   onPressed: actionNo,
                    //   child: Icon(
                    //     FontAwesomeIcons.times,
                    //     size: sizeHor * 2,
                    //     color: Colors.white,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
