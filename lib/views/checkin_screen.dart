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
import 'package:geolocator/geolocator.dart';
import 'package:workcheckin/models/user_locationlist_model.dart';

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
  var far;
  var msg;
  String _deviceid = 'Unknown';
  String platform;
  bool visible;
  GlobalKey<AnimatedListState> animatedListKey = GlobalKey<AnimatedListState>();
  AnimationController emptyListController;
  List<dynamic> ddDatas;
  List<DropdownMenuItem<String>> ddDataToDD = [];
  String ddDataSelected;
  int index;

  @override
  void initState() {
    super.initState();
    getMsg();
    initDeviceId();
    getPT();
    visible = false;
    Future.delayed(Duration(milliseconds: 500), () {
      selectPlace();
    });
  }

  getMsg() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      msg = jsonDecode(sharedPreferences.getString('userMsg'));
    });
  }

  Future<List<UserLocationListModel>> _getLocations() async {
    print('msg: $msg');
    List<UserLocationListModel> listlos = [];
    for (var l in msg['locationList']) {
      UserLocationListModel usermodel = UserLocationListModel(
        l['modelid'],
        l['name'],
        l['orgId'],
        l['branchId'],
        l['latitude'],
        l['longitude'],
        l['far'],
        l['status'],
        l['createDate'],
        l['createBy'],
        l['updateDate'],
        l['updateBy'],
        l['defaultInTime'],
        l['defaultOutTime'],
      );
      print(l['name']);
      listlos.add(usermodel);
    }
    return listlos;
  }

  selectPlace() {
    setState(() {
      ddDatas = msg['locationList'];
    });

    for (int i = 0; i < ddDatas.length; i++) {
      for (int j = i; j <= i; j++) {
        // datalist.add(value)
        // print('lo: ' + ddDatas[i]['name'] + ' ');
        ddDataToDD.add(
          DropdownMenuItem(
            child: Center(
              child: Text(
                ddDatas[i]['name'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: _kanit,
                ),
              ),
            ),
            value: ddDatas[i]['name'].toString(),
          ),
        );
        ddDataSelected = ddDatas[i]['name'];
      }
    }
  }

  _action1() async {
    setState(() {
      place = 'สถานที่1';
      latitude = message['locationList'][0]['latitude'].toString().substring(0, 8);
      longtitude = message['locationList'][0]['longitude'].toString().substring(0, 8);
      loctionID = message['locationList'][0]['modelid'].toString();
    });

    double distanceInMeters = await Geolocator().distanceBetween(13.524517, 99.809289, double.parse(latitude), double.parse(longtitude));
    setState(() {
      far = distanceInMeters.toString();
    });
  }

  _action2() async {
    setState(() {
      place = 'สถานที่2';
      latitude = message['locationList'][1]['latitude'].toString().substring(0, 8);
      longtitude = message['locationList'][1]['longitude'].toString().substring(0, 8);
      loctionID = message['locationList'][1]['modelid'].toString();
    });
    double distanceInMeters = await Geolocator().distanceBetween(13.524517, 99.809289, double.parse(latitude), double.parse(longtitude));
    setState(() {
      far = distanceInMeters.toString();
    });
  }

  _action3() async {
    setState(() {
      place = 'สถานที่ test';
      latitude = message['locationList'][2]['latitude'].toString().substring(0, 8);
      longtitude = message['locationList'][2]['longitude'].toString().substring(0, 8);
      loctionID = message['locationList'][2]['modelid'].toString();
      far = message['locationList'][2]['far'].toString();
    });
    double distanceInMeters = await Geolocator().distanceBetween(13.524517, 99.809289, double.parse(latitude), double.parse(longtitude));
    setState(() {
      far = distanceInMeters.toString();
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
    if (far == null) {
      Alert(
        context: context,
        type: AlertType.warning,
        title: "",
        desc: "กรุณาเลือกสถานที่",
        buttons: [
          DialogButton(
            child: Text(
              "ตกลง",
              style: TextStyle(fontFamily: _kanit, color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            width: 120,
          )
        ],
      ).show();
    } else {
      double fars = double.parse(far);
      var userID = message['cwiUser']['modelid'];

      if (fars <= 50) {
        setState(() {
          visible = true;
        });
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
          headers: {"Authorization": "Basic bWluZGFvbm91YjpidTBuMEByQGRyZWU=", "Content-Type": "application/json"},
        );
        Map<String, dynamic> msg = jsonDecode(response.body);

        if (msg['responseCode'] == '000') {
          setState(() {
            visible = false;
          });

          Alert(
            context: context,
            type: AlertType.success,
            title: "",
            desc: "บันทึกสำเร็จ",
            buttons: [
              DialogButton(
                child: Text(
                  "ตกลง",
                  style: TextStyle(fontFamily: _kanit, color: Colors.white, fontSize: 20),
                ),
                onPressed: () => Navigator.pop(context),
                width: 120,
              )
            ],
          ).show();
        } else {
          setState(() {
            visible = false;
          });

          Alert(
            context: context,
            type: AlertType.error,
            title: "",
            desc: msg['responseDesc'],
            buttons: [
              DialogButton(
                child: Text(
                  "ตกลง",
                  style: TextStyle(fontFamily: _kanit, color: Colors.white, fontSize: 20),
                ),
                onPressed: () => Navigator.pop(context),
                width: 120,
              )
            ],
          ).show();
        }
      } else {
        setState(() {
          visible = false;
        });

        Alert(
          context: context,
          type: AlertType.error,
          title: "",
          desc: "เกิน 50 เมตร",
          buttons: [
            DialogButton(
              child: Text(
                "ตกลง",
                style: TextStyle(fontFamily: _kanit, color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              width: 120,
            )
          ],
        ).show();
      }
    }
  }

  _checkout() async {
    if (far == null) {
      Alert(
        context: context,
        type: AlertType.warning,
        title: "",
        desc: "กรุณาเลือกสถานที่",
        buttons: [
          DialogButton(
            child: Text(
              "ตกลง",
              style: TextStyle(fontFamily: _kanit, color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            width: 120,
          )
        ],
      ).show();
    } else {
      double fars = double.parse(far);
      var userID = message['cwiUser']['modelid'];
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
          headers: {"Authorization": "Basic bWluZGFvbm91YjpidTBuMEByQGRyZWU=", "Content-Type": "application/json"},
        );
        Map<String, dynamic> msg = jsonDecode(response.body);

        if (msg['responseCode'] == '000') {
          Alert(
            context: context,
            type: AlertType.success,
            title: "",
            desc: "บันทึกสำเร็จ",
            buttons: [
              DialogButton(
                child: Text(
                  "ตกลง",
                  style: TextStyle(fontFamily: _kanit, color: Colors.white, fontSize: 20),
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
                  style: TextStyle(fontFamily: _kanit, color: Colors.white, fontSize: 20),
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
                style: TextStyle(fontFamily: _kanit, color: Colors.white, fontSize: 20),
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'วันนี้',
          style: TextStyle(fontFamily: _kanit),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text('เลือกสถานที่',
                        style: TextStyle(
                          fontFamily: _kanit,
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        )),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Center(
                          child: DropdownButtonHideUnderline(
                            child: Center(
                                child: ddDataToDD != null
                                    ? DropdownButton(
                                        items: ddDataToDD,
                                        value: ddDataSelected,
                                        isExpanded: true,
                                        onChanged: (data) async {
                                          print(data);
                                          setState(() {
                                            ddDataSelected = data;

                                            place = 'สถานที่1';
                                            latitude = msg['locationList'][0]['latitude'].toString().substring(0, 8);
                                            longtitude = msg['locationList'][0]['longitude'].toString().substring(0, 8);
                                            loctionID = msg['locationList'][0]['modelid'].toString();
                                          });
                                          double distanceInMeters = await Geolocator().distanceBetween(13.524517, 99.809289, double.parse(latitude), double.parse(longtitude));

                                          far = distanceInMeters.toString();
                                        },
                                      )
                                    : Center(
                                        child: Visibility(visible: true, child: CircularProgressIndicator()),
                                      )),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          place == '' ? 'เลือกสถานที่ก่อน' : place,
                          style: place == '' ? TextStyle(fontFamily: _kanit, fontSize: 18.0, color: Colors.red) : TextStyle(fontFamily: _kanit, fontSize: 18.0, color: Colors.black),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          latitude == '' ? 'latitude / ' : latitude.toString() + ' / ',
                          style: place == '' ? TextStyle(fontFamily: _kanit, fontSize: 18.0, color: Colors.red) : TextStyle(fontFamily: _kanit, fontSize: 18.0, color: Colors.black),
                        ),
                        Text(
                          latitude == '' ? 'longitude' : latitude.toString(),
                          style: place == '' ? TextStyle(fontFamily: _kanit, fontSize: 18.0, color: Colors.red) : TextStyle(fontFamily: _kanit, fontSize: 18.0, color: Colors.black),
                        ),
                      ],
                    ),
                  ],
                ),
                // RaisedButton(
                //   child: Text('asd'),
                //   onPressed: () async {

                //   },
                // ),
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
                    SizedBox(height: MediaQuery.of(context).size.height / 4),
                  ],
                ),
              ],
            ),
            Container(
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

// showmodalsheet
// showModalBottomSheet(
//         shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(30),
//           topRight: Radius.circular(30),
//         )),
//         context: context,
//         builder: (BuildContext context) {
//           return Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               _createTile(context, 'สถานที่1', _action1),
//               _createTile(context, 'สถานที่2'.toString(), _action2),
//               _createTile(context, 'สถานที่ test', _action3),
//             ],
//           );
//         });
