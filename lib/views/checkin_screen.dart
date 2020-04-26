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

final _kanit = 'Kanit';

class CheckinScreen extends StatefulWidget {
  @override
  _CheckinScreenState createState() => _CheckinScreenState();
}

class _CheckinScreenState extends State<CheckinScreen> {
  SharedPreferences sharedPreferences;
  var msg;
  var latitude = '';
  var place = '';
  var longtitude = '';
  var loctionID = '';
  var far;
  String _deviceid = 'Unknown';
  String platform;
  bool visible;
  GlobalKey<AnimatedListState> animatedListKey = GlobalKey<AnimatedListState>();
  AnimationController emptyListController;
  List<dynamic> ddDatas;
  List<String> item = [];
  int _item;

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

  selectPlace() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var msg = jsonDecode(sharedPreferences.getString('userMsg'));
    setState(() {
      ddDatas = msg['locationList'];
      _item = 0;
    });

    for (int i = 0; i < ddDatas.length; i++) {
      for (int j = i; j <= i; j++) {
        item.add(ddDatas[i]['name']);
      }
    }
    print(item);
    place = msg['locationList'][_item]['name'].toString();
    latitude = msg['locationList'][_item]['latitude'].toString();
    longtitude = msg['locationList'][_item]['longitude'].toString().substring(0, 8);
    loctionID = msg['locationList'][_item]['modelid'].toString();
    print('$latitude $longtitude');
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

  _checkin() async {
    double distanceInMeters = await Geolocator().distanceBetween(13.524517, 99.809289, double.parse(latitude), double.parse(longtitude));
    far = distanceInMeters.toString();

    print('far: $far');
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
      var userID = msg['cwiUser']['modelid'];

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
        print(data);
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
    double distanceInMeters = await Geolocator().distanceBetween(13.524517, 99.809289, double.parse(latitude), double.parse(longtitude));
    far = distanceInMeters.toString();
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
      var userID = msg['cwiUser']['modelid'];
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
            desc: 'บันทึกสำเร็จ',
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
            desc: msg['responseDesc'].toString(),
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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('เลือกสถานที่',
                    style: TextStyle(
                      fontFamily: _kanit,
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    )),

                place == ''
                    ? Center(
                        child: Visibility(
                          visible: true,
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : DropdownButton<String>(
                        focusColor: Colors.white,
                        isExpanded: true,
                        hint: new Text(
                          place,
                        ),
                        value: _item == null ? null : item[_item],
                        items: item.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Center(
                              child: Text(
                                value,
                                style: TextStyle(
                                  fontFamily: _kanit,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            // get index
                            _item = item.indexOf(value);

                            // set location
                            place = msg['locationList'][_item]['name'].toString();
                            latitude = msg['locationList'][_item]['latitude'].toString();
                            longtitude = msg['locationList'][_item]['longitude'].toString();
                            loctionID = msg['locationList'][_item]['modelid'].toString();
                          });

                          print('$place $latitude, $longtitude $loctionID');
                        },
                      ),

                SizedBox(height: 20.0),
                Text(
                  place == '' ? 'เลือกสถานที่ก่อน' : place,
                  style: place == '' ? TextStyle(fontFamily: _kanit, fontSize: 20.0, color: Colors.red) : TextStyle(fontFamily: _kanit, fontSize: 20.0, color: Colors.black),
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
                // RaisedButton(
                //   child: Text('asd'),
                //   onPressed: () async {

                //   },
                // ),
                SizedBox(height: 20.0),
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
