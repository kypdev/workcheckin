import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:io' show Platform;
import 'package:device_id/device_id.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final _kanit = 'Kanit';

class CheckinScreen extends StatefulWidget {
  @override
  _CheckinScreenState createState() => _CheckinScreenState();
}

class _CheckinScreenState extends State<CheckinScreen> {
  SharedPreferences sharedPreferences;

  var message;
  var latitude = '';
  var place = '';
  var longtitude = '';
  var loctionID = '';
  var far = '';
  String _deviceid = 'Unknown';
  String platform;

  @override
  void initState() {
    super.initState();
    getMsg();
    initDeviceId();
    getPT();
  }

  getMsg() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var msg = jsonDecode(sharedPreferences.getString('userMsg'));
    setState(() {
      message = msg;
      latitude = message['locationList'][0]['latitude'].toString();
      longtitude = message['locationList'][0]['longitude'].toString();
      place = message['locationList'][0]['name'].toString();
      far = message['locationList'][0]['far'].toString();
    });
  }

  selectPlace(BuildContext context) {
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
              _createTile(context,
                  message['locationList'][0]['name'].toString(), _action1),
              _createTile(context,
                  message['locationList'][1]['name'].toString(), _action2),
              _createTile(context,
                  message['locationList'][2]['name'].toString(), _action3),
            ],
          );
        });
  }

  _action1() {
    print(message['locationList'][2]['name']);
    setState(() {
      place = message['locationList'][0]['name'];
      latitude = message['locationList'][0]['latitude'].toString();
      longtitude = message['locationList'][0]['longitude'].toString();
      loctionID = message['locationList'][0]['modelid'].toString();
      far = message['locationList'][0]['far'].toString();
      print(far);
    });
  }

  _action2() {
    print(message['locationList'][1]['name']);
    setState(() {
      place = message['locationList'][1]['name'];
      latitude = message['locationList'][1]['latitude'].toString();
      longtitude = message['locationList'][1]['longitude'].toString();
      loctionID = message['locationList'][1]['modelid'].toString();
      far = message['locationList'][1]['far'].toString();
    });
  }

  _action3() {
    print(message['locationList'][2]['name']);
    setState(() {
      place = message['locationList'][2]['name'];
      latitude = message['locationList'][2]['latitude'].toString();
      longtitude = message['locationList'][2]['longitude'].toString();
      loctionID = message['locationList'][2]['modelid'].toString();
      far = message['locationList'][2]['far'].toString();
    });
  }

  Future<void> initDeviceId() async {
    String deviceid;

    deviceid = await DeviceId.getID;
    try {
      // todo
    } on PlatformException catch (e) {
      print(e.message);
    }

    if (!mounted) return;

    setState(() {
      _deviceid = '$deviceid';
    });
    print(_deviceid);
  }

  getPT() {
    if (Platform.isAndroid) {
      setState(() {
        platform = '1';
      });
    } else if (Platform.isIOS) {
      setState(() {
        platform = '2';
      });
    } else {
      setState(() {
        platform = 'unknow';
      });
    }
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

  _checkin() async {
    int fars = int.parse(far);
    var userID = message['cwiUser']['modelid'];
    print(fars);
    print(loctionID);
    if (fars <= 50) {
      var data = {
        'userId': userID,
        'deviceId': _deviceid,
        'osMobile': platform,
        'locationId': loctionID,
      };

      var url = 'http://159.138.232.139/service/cwi/v1/user/checkin';

      var response = await http.post(
        url,
        body: json.encode(data),
        headers: {
          "Authorization": "Basic bWluZGFvbm91YjpidTBuMEByQGRyZWU=",
          "Content-Type": "application/json"
        },
      );
      Map<String, dynamic> msg = jsonDecode(response.body);
      print(msg['responseCode']);
      print(data);

      if (msg['responseCode'] == '000') {
        print('success');
        Alert(
          context: context,
          type: AlertType.success,
          title: "",
          desc: "บันทึกสำเร็จ",
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
        Alert(
          context: context,
          type: AlertType.error,
          title: "",
          desc: msg['responseDesc'],
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
    } else {
      Alert(
        context: context,
        type: AlertType.error,
        title: "",
        desc: "เกิน 50 เมตร",
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

  _checkout() async {
    int fars = int.parse(far);
    var userID = message['cwiUser']['modelid'];
    print(fars);
    print(loctionID);
    if (fars <= 50) {
      var data = {
        'userId': userID,
        'deviceId': _deviceid,
        'osMobile': platform,
        'locationId': loctionID,
      };

      var url = 'http://159.138.232.139/service/cwi/v1/user/checkout';

      var response = await http.post(
        url,
        body: json.encode(data),
        headers: {
          "Authorization": "Basic bWluZGFvbm91YjpidTBuMEByQGRyZWU=",
          "Content-Type": "application/json"
        },
      );
      Map<String, dynamic> msg = jsonDecode(response.body);
      print(msg['responseCode']);
      print(data);

      if (msg['responseCode'] == '000') {
        print('success');
        Alert(
          context: context,
          type: AlertType.success,
          title: "",
          desc: "บันทึกสำเร็จ",
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
        Alert(
          context: context,
          type: AlertType.error,
          title: "",
          desc: "บันทึกไม่สำเร็จ",
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
    } else {
      Alert(
        context: context,
        type: AlertType.error,
        title: "",
        desc: "เกิน 50 เมตร",
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('วันนี้', style: TextStyle(fontFamily: _kanit),),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(),
          Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: _checkin,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                      ),
                      child: Icon(
                        FontAwesomeIcons.arrowAltCircleDown,
                        size: 80,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  GestureDetector(
                    onTap: _checkout,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                      child: Icon(
                        FontAwesomeIcons.arrowAltCircleDown,
                        size: 80,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: ()=> selectPlace(context),
                              child: Text(
                  place,
                  style: TextStyle(
                    fontFamily: _kanit,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                '$latitude / $longtitude',
                style: TextStyle(
                  fontFamily: _kanit,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
        ],
      ),
    );
  }
}
