import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ประวัติการลา',
          style: TextStyle(
            fontFamily: _kanit,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
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
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Column(
                            children: <Widget>[
                              Card(
                                elevation: 5.0,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20, bottom: 20, left: 20, right: 20),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              'วันที่ลา : ' +
                                                  snapshot.data[index].leaveDate
                                                      .toString(),
                                              style: TextStyle(
                                                fontFamily: _kanit,
                                                fontSize: 16.0,
                                              ),
                                            ),
                                            SizedBox(height: 10.0),
                                            Text(
                                              'ประเภทการลา : ' +
                                                  snapshot
                                                      .data[index].leaveTypeName
                                                      .toString(),
                                              style: TextStyle(
                                                fontFamily: _kanit,
                                                fontSize: 13.0,
                                              ),
                                            ),
                                            Text(
                                              'ชั่วโมง : ' +
                                                  snapshot.data[index].leaveHour
                                                      .toString(),
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
                                                  snapshot.data[index]
                                                              .approveFlag
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
                                                    fontSize: 13.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              'เหตุผล : ' +
                                                  snapshot.data[index].remark
                                                      .toString(),
                                              style: TextStyle(
                                                fontFamily: _kanit,
                                                fontSize: 13.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                10),
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: RawMaterialButton(
                                            padding: EdgeInsets.all(10),
                                            shape: CircleBorder(
                                              side: BorderSide(
                                                  color: Colors.transparent),
                                            ),
                                            fillColor: Colors.blue,
                                            child: Icon(
                                              FontAwesomeIcons.trashAlt,
                                              color: Colors.white,
                                            ),
                                            onPressed: () async {
                                              setState(() => visible = true);

                                              Alert(
                                                context: context,
                                                type: AlertType.warning,
                                                title:
                                                    "คุณต้องการลบใบลาหรือไม่ ?",
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
                                                      // TODO ok aprove
                                                      var leaveid = snapshot
                                                          .data[index].modelid
                                                          .toString();
                                                      var url =
                                                          'http://159.138.232.139/service/cwi/v1/user/delete_leave';

                                                      var jsonData = {
                                                        "leaveId": leaveid
                                                      };
                                                      print(
                                                          jsonEncode(jsonData));
                                                      var response =
                                                          await http.post(
                                                        url,
                                                        body: jsonEncode(
                                                            jsonData),
                                                        headers: {
                                                          "Authorization":
                                                              "Basic bWluZGFvbm91YjpidTBuMEByQGRyZWU=",
                                                          "Content-Type":
                                                              "application/json"
                                                        },
                                                      );

                                                      Map<String, dynamic>
                                                          message = json.decode(
                                                              response.body);

                                                      print('res: $message');

                                                      if (message[
                                                              'responseCode'] ==
                                                          '000') {
                                                        // Success
                                                        setState(() =>
                                                            visible = false);
                                                        Navigator.pop(context);

                                                        Alert(
                                                            context: context,
                                                            type: AlertType
                                                                .success,
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
                                                                      fontSize:
                                                                          20),
                                                                ),
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      this.context);
                                                                },
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                            ]).show();
                                                      } else {
                                                        // Failed to process
                                                        Navigator.maybePop(
                                                            context);
                                                        setState(() {
                                                          visible = false;
                                                        });
                                                        Alert(
                                                          context: context,
                                                          type:
                                                              AlertType.warning,
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
                                                                    fontSize:
                                                                        20),
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
                                                      setState(() =>
                                                          visible = false);
                                                      Navigator.pop(context);
                                                    },
                                                    gradient:
                                                        LinearGradient(colors: [
                                                      Color.fromRGBO(
                                                          116, 116, 191, 1.0),
                                                      Color.fromRGBO(
                                                          52, 138, 199, 1.0)
                                                    ]),
                                                  )
                                                ],
                                              ).show();
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
                          'ชั่วโมง555 : $leaveHour',
                          style: TextStyle(
                            fontFamily: _kanit,
                            fontSize: 13.0,
                          ),
                        ),
                        Text(
                          'as;dljf;lasjkdfl',
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
