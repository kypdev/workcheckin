import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:io' show Platform;
import 'package:device_id/device_id.dart';

final _kanit = 'Kanit';

class EmployeeScreen extends StatefulWidget {
  Map<String, dynamic> message;
  EmployeeScreen({Key key, this.message}) : super(key: key);

  @override
  _EmployeeScreenState createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  var latitude = '';
  var place = '';
  var longtitude = '';
  var loctionID = '';
  var far = '';
  SharedPreferences sharedPreferences;
  String _deviceid = 'Unknown';
  String platform;
  var message;

  setMessage() async {
    print('setmessaage');
    sharedPreferences = await SharedPreferences.getInstance();
    Map<String, dynamic> msg = jsonDecode(sharedPreferences.getString('userMsg'));
    setState(() {
      message = msg;

      
    });
    print(message['locationList'][0]);
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
    }else{
      setState(() {
        platform = 'unknow';
      });
    }
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
              _createTile(
                  context, widget.message['locationList'][0]['name'], _action1),
              _createTile(
                  context, widget.message['locationList'][1]['name'], _action2),
              _createTile(
                  context, widget.message['locationList'][2]['name'], _action3),
            ],
          );
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


  _action1() {
    print(widget.message['locationList'][2]['name']);
    setState(() {
      place = widget.message['locationList'][0]['name'];
      latitude = widget.message['locationList'][0]['latitude'].toString();
      longtitude = widget.message['locationList'][0]['longitude'].toString();
      loctionID = widget.message['locationList'][0]['modelid'].toString();
      far = widget.message['locationList'][0]['far'].toString();
    });
  }

  _action2() {
    print(widget.message['locationList'][1]['name']);
    setState(() {
      place = widget.message['locationList'][1]['name'];
      latitude = widget.message['locationList'][1]['latitude'].toString();
      longtitude = widget.message['locationList'][1]['longitude'].toString();
      loctionID = widget.message['locationList'][1]['modelid'].toString();
      far = widget.message['locationList'][1]['far'].toString();
    });
  }

  _action3() {
    print(widget.message['locationList'][2]['name']);
    setState(() {
      place = widget.message['locationList'][2]['name'];
      latitude = widget.message['locationList'][2]['latitude'].toString();
      longtitude = widget.message['locationList'][2]['longitude'].toString();
      loctionID = widget.message['locationList'][2]['modelid'].toString();
      far = widget.message['locationList'][2]['far'].toString();
    });
  }

  _checkin() async {
    int fars = int.parse(far);
    var userID = widget.message['cwiUser']['employeeId'];
    print(loctionID);
    if (fars <= 50) {
      var data = {
        'userId': userID,
        'deviceId': '$_deviceid',
        'osMobile': '$platform',
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
      Map<String, dynamic> message = jsonDecode(response.body);
      print(message);
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
  }

  _checkout() async {
    int fars = int.parse(far);
    var userID = widget.message['cwiUser']['employeeId'];
    print(loctionID);
    if (fars <= 50) {
      var data = {
        'userId': userID,
        'deviceId': '$_deviceid',
        'osMobile': '$platform',
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
      Map<String, dynamic> message = jsonDecode(response.body);
      print(message);
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
  }

  @override
  void initState() {
    super.initState();
    initDeviceId();
    getPT();
    latitude = widget.message['locationList'][0]['latitude'].toString();
    longtitude = widget.message['locationList'][0]['longitude'].toString();
    place = widget.message['locationList'][0]['name'].toString();
    // setMessage();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Today'),
              IconButton(
                onPressed: () => selectPlace(context),
                icon: Icon(Icons.location_on),
              ),
            ],
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(),
            RaisedButton(
              child: Text('aaa'),
              onPressed: setMessage,
            ),
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
                Text(place),
                SizedBox(height: 10),
                Text('$latitude / $longtitude'),
                SizedBox(height: 50),
              ],
            ),
          ],
        ),
      ),
    );
  }
}