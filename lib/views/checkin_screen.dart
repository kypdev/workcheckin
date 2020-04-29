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
  var resLocationLists;
  int locationListIndexDD;
  List<dynamic> locationData;
  List<String> locationItem = [];
  var locationId;
  int _item;

  @override
  void initState() {
    super.initState();
    getMsg();
    initDeviceId();
    getPT();
    visible = false;
    selectPlace();
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
    var branchid = msg['cwiUser']['branchId'].toString();

    var url = 'http://159.138.232.139/service/cwi/v1/master/get_location_lish_for_user';
    var data = {"branchId": branchid};
    var response = await http.post(
      url,
      body: jsonEncode(data),
      headers: {"Authorization": "Basic bWluZGFvbm91YjpidTBuMEByQGRyZWU=", "Content-Type": "application/json"},
    );
    Map<String, dynamic> messages = jsonDecode(response.body);
    print(messages);
    setState(() => _item =0);
    setState(() => resLocationLists = messages);
    setState(() => locationListIndexDD = 0);
    setState(() => place = messages['locationList'][0]['name']);
    setState(() => locationData = messages['locationList']);
    setState(() => locationId = messages['locationList'][0]['modelid']);
    setState(() => latitude = messages['locationList'][0]['latitude'].toString());
    setState(() => longtitude = messages['locationList'][0]['modlongitudeelid'].toString());

    if (resLocationLists['locationList'].toString() == '[]') {
      locationItem.add('ไม่พบข้อมูล');
    } else {
      for (int i = 0; i < locationData.length; i++) {
        for (int j = i; j <= i; j++) {
          locationItem.add(locationData[i]['name']);
        }
      }
    }
    print(locationItem);
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
                RaisedButton(
                  child: Text('test'),
                  onPressed: () {
                    selectPlace();
                  },
                ),
                //     Text('เลือกสถานที่',
                //         style: TextStyle(
                //           fontFamily: _kanit,
                //           fontSize: 25.0,
                //           fontWeight: FontWeight.bold,
                //         )),

                place == ''
                    ? Center(
                        child: Visibility(
                          visible: true,
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: DropdownButton<String>(
                            focusColor: Colors.white,
                            isExpanded: true,
                            hint: new Text(
                              place,
                            ),
                            value: _item == null ? null : locationItem[_item],
                            items: locationItem.map((String value) {
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
                                _item = locationItem.indexOf(value);

                                // set location
                                place = resLocationLists['locationList'][_item]['name'].toString();
                                latitude = resLocationLists['locationList'][_item]['latitude'].toString();
                                longtitude = resLocationLists['locationList'][_item]['longitude'].toString();
                                loctionID = resLocationLists['locationList'][_item]['modelid'].toString();
                              });

                              print('$place $latitude, $longtitude $loctionID');
                            },
                          ),
                      ),
                    ),

                SizedBox(height: 50),

                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 3,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/card-check.png'),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 70, right: 70),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          onTap: _checkin,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                  'assets/images/checkin.png',
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: _checkout,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                  'assets/images/checkout.png',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                //     SizedBox(height: 20.0),
                //     Text(
                //       place == '' ? 'เลือกสถานที่ก่อน' : place,
                //       style: place == '' ? TextStyle(fontFamily: _kanit, fontSize: 20.0, color: Colors.red) : TextStyle(fontFamily: _kanit, fontSize: 20.0, color: Colors.black),
                //     ),

                //     SizedBox(height: 20.0),
                //     Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: <Widget>[
                //         Text(
                //           latitude == '' ? 'latitude / ' : latitude.toString() + ' / ',
                //           style: place == '' ? TextStyle(fontFamily: _kanit, fontSize: 18.0, color: Colors.red) : TextStyle(fontFamily: _kanit, fontSize: 18.0, color: Colors.black),
                //         ),
                //         Text(
                //           latitude == '' ? 'longitude' : latitude.toString(),
                //           style: place == '' ? TextStyle(fontFamily: _kanit, fontSize: 18.0, color: Colors.red) : TextStyle(fontFamily: _kanit, fontSize: 18.0, color: Colors.black),
                //         ),
                //       ],
                //     ),
                //     // RaisedButton(
                //     //   child: Text('asd'),
                //     //   onPressed: () async {

                //     //   },
                //     // ),
                //     SizedBox(height: 20.0),
                //     Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: <Widget>[
                //         GestureDetector(
                //           onTap: _checkin,
                //           child: Container(
                //             width: 100,
                //             height: 100,
                //             decoration: BoxDecoration(
                //               shape: BoxShape.circle,
                //               color: Colors.green,
                //             ),
                //             child: Icon(
                //               FontAwesomeIcons.arrowAltCircleDown,
                //               size: 80,
                //               color: Colors.white,
                //             ),
                //           ),
                //         ),
                //         SizedBox(width: 20),
                //         GestureDetector(
                //           onTap: _checkout,
                //           child: Container(
                //             width: 100,
                //             height: 100,
                //             decoration: BoxDecoration(
                //               shape: BoxShape.circle,
                //               color: Colors.red,
                //             ),
                //             child: Icon(
                //               FontAwesomeIcons.arrowAltCircleDown,
                //               size: 80,
                //               color: Colors.white,
                //             ),
                //           ),
                //         ),
                //       ],
                //     ),
                //     SizedBox(height: MediaQuery.of(context).size.height / 4),
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
