import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:io' show Platform;
import 'package:device_id/device_id.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:workcheckin/models/size_config.dart';

final _kanit = 'Kanit';
final oCcy = new NumberFormat("###0.00", "en_US");
final AlertStyle _alertStyle = AlertStyle(
  titleStyle: TextStyle(
    fontFamily: _kanit,
  ),
);

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
    var url =
        'http://159.138.232.139/service/cwi/v1/master/get_location_lish_for_user';
    var data = {"branchId": branchid};
    var response = await http.post(
      url,
      body: jsonEncode(data),
      headers: {
        "Authorization": "Basic bWluZGFvbm91YjpidTBuMEByQGRyZWU=",
        "Content-Type": "application/json"
      },
    );
    Map<String, dynamic> messages = jsonDecode(response.body);
    setState(() => _item = 0);
    setState(() => resLocationLists = messages);
    setState(() => locationListIndexDD = 0);
    setState(() => place = messages['locationList'][0]['name']);
    setState(() => locationData = messages['locationList']);
    setState(
        () => loctionID = messages['locationList'][0]['modelid'].toString());
    setState(
        () => latitude = messages['locationList'][0]['latitude'].toString());
    setState(
        () => longtitude = messages['locationList'][0]['longitude'].toString());

    if (resLocationLists['locationList'].toString() == '[]') {
      locationItem.add('ไม่พบข้อมูล');
    } else {
      for (int i = 0; i < locationData.length; i++) {
        for (int j = i; j <= i; j++) {
          locationItem.add(locationData[i]['name']);
        }
      }
    }
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
    double distanceInMeters = await Geolocator().distanceBetween(
        13.524517, 99.809289, double.parse(latitude), double.parse(longtitude));
    far = distanceInMeters.toString();
    var farSetFormat = oCcy.format(double.parse(far));
    var resFar = resLocationLists['locationList'][0]['far'];
    var eqlFar = double.parse(farSetFormat);

    if (eqlFar <= resFar) {
      var userID = msg['cwiUser']['modelid'];
      var data = {
        'userId': userID,
        'deviceId': _deviceid,
        'osMobile': platform,
        'locationId': loctionID
      };
      var url = 'http://159.138.232.139/service/cwi/v2/user/checkin';
      var response = await http.post(
        url,
        body: json.encode(data),
        headers: {
          "Authorization": "Basic bWluZGFvbm91YjpidTBuMEByQGRyZWU=",
          "Content-Type": "application/json"
        },
      );
      Map<String, dynamic> resMsgCheckin = jsonDecode(response.body);
      var checkinResOk = resMsgCheckin['responseCode'].toString();
      if (checkinResOk == '000') {
        // Alert Save Success
        Alert(
          context: context,
          type: AlertType.success,
          title: 'บันทึกสำเร็จ',
          style: _alertStyle,
          desc: '',
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
        // Alert Cannot Save
        Alert(
          context: context,
          type: AlertType.error,
          title: resMsgCheckin['responseDesc'].toString(),
          style: _alertStyle,
          desc: '',
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
        type: AlertType.warning,
        title: 'คุณห่างเกินรัศมี 100 เมตร',
        desc: '',
        style: _alertStyle,
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
    double distanceInMeters = await Geolocator().distanceBetween(
        13.524517, 99.809289, double.parse(latitude), double.parse(longtitude));
    far = distanceInMeters.toString();
    var farSetFormat = oCcy.format(double.parse(far));
    var resFar = resLocationLists['locationList'][0]['far'];

    if (double.parse('$farSetFormat') <= resFar) {
      var userID = msg['cwiUser']['modelid'];
      var data = {
        'userId': userID,
        'deviceId': _deviceid,
        'osMobile': platform,
        'locationId': loctionID
      };
      var url = 'http://159.138.232.139/service/cwi/v2/user/checkout';
      var response = await http.post(
        url,
        body: json.encode(data),
        headers: {
          "Authorization": "Basic bWluZGFvbm91YjpidTBuMEByQGRyZWU=",
          "Content-Type": "application/json"
        },
      );
      Map<String, dynamic> resMsgCheckin = jsonDecode(response.body);
      var checkinResOk = resMsgCheckin['responseCode'].toString();

      if (checkinResOk == '000') {
        Alert(
          context: context,
          type: AlertType.success,
          title: 'บันทึกสำเร็จ',
          style: _alertStyle,
          desc: '',
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
          title: resMsgCheckin['responseDesc'].toString(),
          style: _alertStyle,
          desc: '',
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
      // Alert Distance More Than Far from service
      Alert(
        context: context,
        type: AlertType.warning,
        title: 'คุณห่างเกินรัศมี 100 เมตร',
        style: _alertStyle,
        desc: '',
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
    SizeConfig().init(context);
    var sizeHor = SizeConfig.safeBlockHorizontal;
    var sizeVer = SizeConfig.safeBlockVertical;
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
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

                                place = resLocationLists['locationList'][_item]
                                        ['name']
                                    .toString();
                                latitude = resLocationLists['locationList']
                                        [_item]['latitude']
                                    .toString();
                                longtitude = resLocationLists['locationList']
                                        [_item]['longitude']
                                    .toString();
                                loctionID = resLocationLists['locationList']
                                        [_item]['modelid']
                                    .toString();
                              });
                            },
                          ),
                        ),
                      ),
                SizedBox(height: 50),
                Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/card-check.png',
                      width: sizeHor * 90,
                      height: sizeVer * 60,
                      filterQuality: FilterQuality.high,
                      excludeFromSemantics: true,
                      fit: BoxFit.fill,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                          onTap: _checkin,
                          child: Image.asset(
                            'assets/images/checkin.png',
                            width: sizeHor * 30,
                          ),
                        ),
                        InkWell(
                          onTap: _checkout,
                          child: Image.asset(
                            'assets/images/checkout.png',
                            width: sizeHor * 30,
                          ),
                        ),
                      ],
                    )
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
