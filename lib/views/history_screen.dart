import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workcheckin/models/leave_model.dart';
import 'package:workcheckin/models/size_config.dart';

final _kanit = 'Kanit';
final AlertStyle _alertStyle = AlertStyle(
  titleStyle: TextStyle(
    fontFamily: _kanit,
  ),
);

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  var employee = 'พนักงาน';
  SharedPreferences sharedPreferences;
  Map<String, dynamic> message;
  var userID;
  bool visible = false;

  @override
  void initState() {
    super.initState();
    getMsg();
  }

  getMsg() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var msg = jsonDecode(sharedPreferences.getString('userMsg'));
    setState(() {
      userID = msg['cwiUser']['modelid'];
    });
  }

  Future<List<LeaveModel>> _getLeave() async {
    var url =
        'http://159.138.232.139/service/cwi/v1/user/request_leave_list_by_user';

    var data = {"userId": userID};

    var response = await http.post(
      url,
      body: json.encode(data),
      headers: {
        "Authorization": "Basic bWluZGFvbm91YjpidTBuMEByQGRyZWU=",
        "Content-Type": "application/json"
      },
    );

    Map<String, dynamic> msg = jsonDecode(response.body);

    if (msg['trnLeaveList'].toString() == '[]') {
      return null;
    } else {
      List<LeaveModel> leaveModels = [];

      for (var leave in msg['trnLeaveList']) {
        LeaveModel leaveModel = LeaveModel(
          leave['modelid'],
          leave['userId'],
          leave['leaveTypeCode'],
          leave['leaveTypeName'],
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
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var sizeHor = SizeConfig.safeBlockHorizontal;
    var sizeVer = SizeConfig.safeBlockVertical;
    var screenSize = MediaQuery.of(context).size;

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
              future: _getLeave(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return Container();
                } else {
                  return Container(
                    padding: EdgeInsets.only(
                      top: sizeVer * 1.2,
                      bottom: sizeVer * 1.2,
                    ),
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: EdgeInsets.only(
                              left: sizeHor * 2,
                              right: sizeHor * 2,
                              bottom: sizeVer * 1.2),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            elevation: 5.0,
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: screenSize.width / 22,
                                right: screenSize.width / 22,
                                top: screenSize.height / 48,
                                bottom: screenSize.height / 48,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Container(
                                    width: screenSize.width / 1.6,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'วันที่ลา : ' +
                                              snapshot.data[index].leaveDate
                                                  .toString(),
                                          style: TextStyle(
                                            fontFamily: _kanit,
                                            fontSize: screenSize.width / 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: sizeVer * 1.5),
                                        Text(
                                          'ประเภทการลา : ' +
                                              snapshot.data[index].leaveTypeName
                                                  .toString(),
                                          style: TextStyle(
                                            fontFamily: _kanit,
                                            fontSize: screenSize.width / 24,
                                          ),
                                        ),
                                        Text(
                                          'ชั่วโมง : ' +
                                              snapshot.data[index].leaveHour
                                                  .toString(),
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
                                              snapshot.data[index].approveFlag
                                                          .toString() ==
                                                      '0'
                                                  ? 'รอการอนุมัติ'
                                                  : snapshot.data[index]
                                                              .approveFlag
                                                              .toString() ==
                                                          '1'
                                                      ? 'อนุมัติการลา'
                                                      : 'ไม่อนุมัติการลา',
                                              style: TextStyle(
                                                fontFamily: _kanit,
                                                fontSize: screenSize.width / 24,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2,
                                              child: Text(
                                                'เหตุผล : ' +
                                                    snapshot.data[index].remark
                                                        .toString(),
                                                style: TextStyle(
                                                  fontFamily: _kanit,
                                                  fontSize:
                                                      screenSize.width / 24,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: InkWell(
                                      onTap: () async {
                                        var apprFlag = snapshot
                                            .data[index].approveFlag
                                            .toString();

                                        int apprvFlagInt = int.parse(apprFlag);

                                        if (apprvFlagInt == 1) {
                                          // Cannot delete leave letter
                                          Alert(
                                              context: context,
                                              type: AlertType.warning,
                                              title: 'ไม่สามารถลบใบลนี้ได้!!!',
                                              desc: "",
                                              style: _alertStyle,
                                              buttons: [
                                                DialogButton(
                                                  child: Text(
                                                    "ตกลง",
                                                    style: TextStyle(
                                                        fontFamily: _kanit,
                                                        color: Colors.white,
                                                        fontSize: 20),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(this.context);
                                                  },
                                                  color: Colors.green,
                                                ),
                                              ]).show();
                                        } else {
                                          // Can delte leave letter
                                          Alert(
                                            context: context,
                                            type: AlertType.warning,
                                            title: "คุณต้องการลบใบลาหรือไม่ ?",
                                            style: _alertStyle,
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
                                                  setState(
                                                      () => visible = true);
                                                  var leaveid = snapshot
                                                      .data[index].modelid
                                                      .toString();
                                                  var url =
                                                      'http://159.138.232.139/service/cwi/v1/user/delete_leave';

                                                  var jsonData = {
                                                    "leaveId": leaveid
                                                  };

                                                  var response =
                                                      await http.post(
                                                    url,
                                                    body: jsonEncode(jsonData),
                                                    headers: {
                                                      "Authorization":
                                                          "Basic bWluZGFvbm91YjpidTBuMEByQGRyZWU=",
                                                      "Content-Type":
                                                          "application/json"
                                                    },
                                                  );

                                                  Map<String, dynamic> message =
                                                      json.decode(
                                                          response.body);

                                                  if (message['responseCode'] ==
                                                      '000') {
                                                    // Success
                                                    setState(
                                                        () => visible = false);
                                                    Navigator.pop(context);

                                                    Alert(
                                                        context: context,
                                                        type: AlertType.success,
                                                        title: message[
                                                                'responseDesc']
                                                            .toString(),
                                                        desc: "",
                                                        buttons: [
                                                          DialogButton(
                                                            child: Text(
                                                              "ตกลง",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      _kanit,
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 20),
                                                            ),
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  this.context);
                                                            },
                                                            color: Colors.green,
                                                          ),
                                                        ]).show();
                                                  } else {
                                                    // Failed to process
                                                    Navigator.maybePop(context);
                                                    setState(() {
                                                      visible = false;
                                                    });
                                                    Alert(
                                                      context: context,
                                                      type: AlertType.warning,
                                                      title: message[
                                                              'responseDesc']
                                                          .toString(),
                                                      desc: "",
                                                      buttons: [
                                                        DialogButton(
                                                          child: Text(
                                                            "ตกลง",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    _kanit,
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 20),
                                                          ),
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context),
                                                          color: Colors.red,
                                                        )
                                                      ],
                                                    ).show();
                                                  }
                                                },
                                                color: Color.fromRGBO(
                                                    0, 179, 134, 1.0),
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
                                                  setState(
                                                      () => visible = false);
                                                  Navigator.pop(context);
                                                },
                                                gradient: LinearGradient(
                                                    colors: [
                                                      Color.fromRGBO(
                                                          116, 116, 191, 1.0),
                                                      Color.fromRGBO(
                                                          52, 138, 199, 1.0)
                                                    ]),
                                              )
                                            ],
                                          ).show();
                                        }
                                      },
                                      child: Container(
                                        width: screenSize.width / 8,
                                        height: screenSize.height / 16,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.blue,
                                        ),
                                        child: Icon(
                                          FontAwesomeIcons.trashAlt,
                                          color: Colors.white,
                                          size: screenSize.width / 13,
                                        ),
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
                }
              },
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
}
