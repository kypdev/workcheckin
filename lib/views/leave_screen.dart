import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _kanit = 'Kanit';

class LeaveScreen extends StatefulWidget {
  @override
  _LeaveScreenState createState() => _LeaveScreenState();
}

const String MIN_DATETIME = '2019-05-15 09:23:10';
const String MAX_DATETIME = '2019-06-03 21:11:00';
const String INIT_DATETIME = '2019-05-16 09:00:00';

class _LeaveScreenState extends State<LeaveScreen> {
  var typeLeave = 'ค่าเริ่มต้น';
  final format = DateFormat("dd/MM/yyyy");
  var dateStr = '20/2/2020';
  bool _showTitle = true;
  var msgStr;
  var msgCode = '';
  var leaveTypeStr = '';
  final _formKey = GlobalKey<FormState>();
  DateTimePickerLocale _locale = DateTimePickerLocale.en_us;
  String _format = 'yyyy-MMMM-dd';
  DateTime _dateTime = DateTime.now();
  TextEditingController hrCtrl = TextEditingController();
  TextEditingController remarkCtrl = TextEditingController();
  SharedPreferences sharedPreferences;
  var message;

  void _showDateTimePicker() {
    return DatePicker.showDatePicker(
      context,
      pickerTheme: DateTimePickerTheme(
        showTitle: _showTitle,
        confirm: Text('ตกลง',
            style: TextStyle(color: Colors.red, fontFamily: _kanit)),
        cancel: Text('ยกเลิก',
            style: TextStyle(color: Colors.cyan, fontFamily: _kanit)),
      ),
      initialDateTime: _dateTime,
      dateFormat: _format,
      locale: _locale,
      onClose: () {
        setState(() {
          dateStr = _dateTime.day.toString() +
              '/' +
              _dateTime.month.toString() +
              '/' +
              _dateTime.year.toString();
        });
      },
      onCancel: () => print('onCancel'),
      onChange: (dateTime, List<int> index) {
        setState(() {
          _dateTime = dateTime;
        });
      },
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          _dateTime = dateTime;
        });
      },
    );
  }

  _getLeaveType() async {
    var url = 'http://159.138.232.139/service/cwi/v1/master/getLeaveTypeList';

    var response = await http.post(
      url,
      body: '{}',
      headers: {
        "Authorization": "Basic bWluZGFvbm91YjpidTBuMEByQGRyZWU=",
        "Content-Type": "application/json"
      },
    );

    Map<String, dynamic> message = jsonDecode(response.body);

    print('levae: $message');
    setState(() {
      msgStr = message;
    });
  }

  getMsg() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var msg = jsonDecode(sharedPreferences.getString('userMsg'));
    setState(() {
      message = msg;
      
    });
  }
  getUserid() {
    print(message['cwiUser']['modelid'].toString());
  }
  

  _selectTypeLeave() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        )),
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _createTile(
                  context, msgStr['leaveTypeList'][0]['description'], _action1),
              _createTile(
                  context, msgStr['leaveTypeList'][1]['description'], _action2),
              _createTile(
                  context, msgStr['leaveTypeList'][2]['description'], _action3),
            ],
          );
        });
  }

  _action1() {
    setState(() {
      msgCode = msgStr['leaveTypeList'][0]['code'].toString();
      leaveTypeStr = msgStr['leaveTypeList'][0]['description'].toString();
      print(msgCode);
    });
  }

  _action2() {
    setState(() {
      msgCode = msgStr['leaveTypeList'][1]['code'].toString();
      leaveTypeStr = msgStr['leaveTypeList'][1]['description'].toString();
      print(msgCode);
    });
  }

  _action3() {
    setState(() {
      msgCode = msgStr['leaveTypeList'][2]['code'].toString();
      leaveTypeStr = msgStr['leaveTypeList'][2]['description'].toString();
      print(msgCode);
    });
  }

  ListTile _createTile(BuildContext context, String name, Function action) {
    return ListTile(
      title: Text(name),
      onTap: () {
        Navigator.pop(context);
        action();
      },
    );
  }

  sendLeave() async {
    var userID = message['cwiUser']['modelid'];
    print(remarkCtrl.text);
    var url = 'http://159.138.232.139/service/cwi/v1/user/request_leave';
    if (_formKey.currentState.validate()) {
      var data = {
        "leaveId": "",
        "userId": userID,
        "leaveDate": dateStr,
        "leaveHour": hrCtrl.text.trim(),
        "leaveCode": msgCode,
        "approveFlag": "",
        "remark": remarkCtrl.text
      };

      var response = await http.post(
        url,
        body: json.encode(data),
        headers: {
          "Authorization": "Basic bWluZGFvbm91YjpidTBuMEByQGRyZWU=",
          "Content-Type": "application/json"
        },
      );

      Map<String, dynamic> message = jsonDecode(response.body);

      print(message);
      if (message['responseCode'] == '000') {
        Alert(
          context: context,
          type: AlertType.success,
          title: "",
          desc: "บันทึกสำเร้จ",
          buttons: [
            DialogButton(
              child: Text(
                "ตกลง",
                style: TextStyle(
                    fontFamily: _kanit, color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              width: 120,
            )
          ],
        ).show();
      }else{
        Alert(
          context: context,
          type: AlertType.error,
          title: "",
          desc: "บันทึกไม่สำเร้จ",
          buttons: [
            DialogButton(
              child: Text(
                "ตกลง",
                style: TextStyle(
                    fontFamily: _kanit, color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              width: 120,
            )
          ],
        ).show();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getLeaveType();
    getMsg();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              'ลางาน',
              style: TextStyle(
                fontFamily: _kanit,
              ),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Stack(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      showDate(
                        date: dateStr,
                        action: _showDateTimePicker,
                      ),
                      getTypeLeave(
                        action: _selectTypeLeave,
                        leaveType: leaveTypeStr,
                      ),
                      hoursLeave(hrsCtrl: hrCtrl, remarkCtrl: remarkCtrl),
                      RaisedButton(
                        color: Colors.blueAccent,
                        onPressed: sendLeave,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'ตกลง',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: _kanit,
                              ),
                            ),
                          ],
                        ),
                      ),

                      RaisedButton(
                        child: Text('aa'),
                        onPressed: getUserid,
                      ),
                      
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget showDate({
    date,
    action,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 20),
        Text(
          'วันที่',
          style: TextStyle(
              fontFamily: _kanit, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          onTap: action,
          child: Row(
            children: <Widget>[
              Text(
                date,
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: _kanit,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
        Divider(
          color: Colors.black54,
          thickness: 1,
        ),
      ],
    );
  }

  Widget getTypeLeave({
    action,
    leaveType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'ประเภทการลา',
          textAlign: TextAlign.start,
          style: TextStyle(
            fontFamily: _kanit,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              '$leaveType',
              style: TextStyle(
                fontFamily: _kanit,
                color: Colors.black54,
                fontSize: 18.0,
              ),
            ),
            GestureDetector(
                onTap: action,
                child: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black54,
                )),
          ],
        ),
        Divider(
          color: Colors.black54,
          thickness: 1,
        ),
      ],
    );
  }

  Widget hoursLeave({
    hrsCtrl,
    remarkCtrl,
  }) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'ชั่วโมงลา',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontFamily: _kanit,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextFormField(
            controller: hrsCtrl,
            validator: (value) {
              if (value.isEmpty) {
                return 'ชั่วโมงการลาห้ามว่าง!!';
              }
              return null;
            },
          ),
          Text(
            'รายละเอียดการลา',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontFamily: _kanit,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextFormField(
            controller: remarkCtrl,
            validator: (value) {
              if (value.isEmpty) {
                return 'รายละเอียดการลาห้ามว่าง!!';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
