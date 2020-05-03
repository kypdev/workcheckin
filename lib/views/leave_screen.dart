import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:workcheckin/models/size_config.dart';

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
  var dateStr = '';
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
  var _currentInfIntValue = '1';
  NumberPicker integerInfiniteNumberPicker;
  List<String> item = [];
  int _item;
  List<dynamic> leaveDDdata;
  var msgobj;
  bool visible;

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

  _setDDdata() {
    setState(() {
      msgobj = msgStr['leaveTypeList'];
    });

    for (int i = 0; i < msgobj.length; i++) {
      for (int j = i; j <= i; j++) {
        item.add(msgobj[i]['name']);
      }
    }
    leaveTypeStr = msgStr['leaveTypeList'][0]['name'];
  }

  getMsg() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var msg = jsonDecode(sharedPreferences.getString('userMsg'));
    setState(() {
      message = msg;
    });
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

    Map<String, dynamic> messages = jsonDecode(response.body);

    setState(() {
      msgStr = messages;
    });
  }

  sendLeave() async {
    var userID = message['cwiUser']['modelid'];

    var url = 'http://159.138.232.139/service/cwi/v1/user/request_leave';
    if (_formKey.currentState.validate()) {
      setState(() => visible = true);
      var data = {
        "leaveId": "",
        "userId": userID,
        "leaveDate": dateStr,
        "leaveHour": _currentInfIntValue.toString(),
        "leaveCode": msgCode,
        "approveFlag": "0",
        "remark": remarkCtrl.text.trim()
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

      if (message['responseCode'] == '000') {
        setState(() => visible = false);
        Alert(
          context: context,
          type: AlertType.success,
          title: "",
          desc: "บันทึกใบลาสำเร็จ",
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
      } else {
        setState(() => visible = false);
        Alert(
          context: context,
          type: AlertType.error,
          title: "",
          desc: message['responseDesc'].toString(),
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
    Future.delayed(Duration(milliseconds: 1000), () {
      _setDDdata();
    });
    setState(() {
      dateStr = _dateTime.day.toString() +
          '/' +
          _dateTime.month.toString() +
          '/' +
          _dateTime.year.toString();
      visible = false;
      msgCode = '1';
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var sizeHor = SizeConfig.safeBlockHorizontal;
    var sizeVer = SizeConfig.safeBlockVertical;
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
        body: Stack(
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
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: sizeVer * 1.5),
                    showDate(
                      date: dateStr,
                      action: _showDateTimePicker,
                    ),
                    SizedBox(height: sizeVer * 4),
                    getTypeLeave(
                      action: () {},
                      leaveType: leaveTypeStr,
                    ),
                    SizedBox(height: sizeVer * 4),
                    hoursLeave(
                      hrsCtrl: hrCtrl,
                      remarkCtrl: remarkCtrl,
                      hours: _currentInfIntValue.toString(),
                    ),
                    SizedBox(height: sizeVer * 4),
                    RaisedButton(
                      elevation: 5.0,
                      padding: EdgeInsets.symmetric(vertical: sizeVer * 1.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
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
                              fontSize: sizeHor * 5.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: sizeVer * 10),
                  ],
                ),
              ),
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

  Widget showDate({
    date,
    action,
  }) {
    SizeConfig().init(context);
    var sizeHor = SizeConfig.safeBlockHorizontal;
    var sizeVer = SizeConfig.safeBlockVertical;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 20),
        Text(
          'วันที่',
          style: TextStyle(
            fontFamily: _kanit,
            fontSize: sizeHor * 5,
            fontWeight: FontWeight.bold,
          ),
        ),
        GestureDetector(
          onTap: action,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: sizeVer * 6.5,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    date,
                    style: TextStyle(
                      fontSize: sizeHor * 4,
                      fontFamily: _kanit,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
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
    SizeConfig().init(context);
    var sizeHor = SizeConfig.safeBlockHorizontal;
    var sizeVer = SizeConfig.safeBlockVertical;
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'ประเภทการลา',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontFamily: _kanit,
              fontSize: sizeHor * 5,
              fontWeight: FontWeight.bold,
            ),
          ),
          DropdownButton<String>(
            underline: Container(),
            isExpanded: true,
            hint: new Text(leaveTypeStr),
            value: _item == null ? null : item[_item],
            items: item.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(fontSize: sizeHor * 4, fontFamily: _kanit),
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                // get index
                _item = item.indexOf(value);
                msgCode = msgStr['leaveTypeList'][_item]['code'].toString();
                leaveTypeStr =
                    msgStr['leaveTypeList'][_item]['description'].toString();
                print(msgCode);
              });
            },
          ),
          Divider(
            color: Colors.black54,
            thickness: 1,
          ),
        ],
      ),
    );
  }

  Widget hoursLeave({
    hrsCtrl,
    remarkCtrl,
    hours,
  }) {
    List<String> hourItems = ['1', '2', '3', '4', '5', '6', '7', '8'];
    SizeConfig().init(context);
    var sizeHor = SizeConfig.safeBlockHorizontal;
    var sizeVer = SizeConfig.safeBlockVertical;
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
              fontSize: sizeHor * 5,
              fontWeight: FontWeight.bold,
            ),
          ),
          DropdownButton<String>(
            isExpanded: true,
            value: _currentInfIntValue,
            iconSize: 24,
            elevation: 16,
            style: TextStyle(
                fontSize: sizeHor * 4, fontFamily: _kanit, color: Colors.black),
            onChanged: (String newValue) {
              setState(() {
                _currentInfIntValue = newValue;
              });
            },
            items: hourItems.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          Divider(
            color: Colors.black54,
            thickness: 1,
          ),
          SizedBox(height: sizeVer * 4),
          Text(
            'รายละเอียดการลา',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontFamily: _kanit,
              fontSize: sizeHor * 5,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: sizeVer * 2),
          TextFormField(
            controller: remarkCtrl,
            decoration: InputDecoration(
              fillColor: Colors.black12.withOpacity(0.059),
              filled: true,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 1.5),
                borderRadius: BorderRadius.circular(100),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(100),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.transparent,
                ),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
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
