import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_id/device_id.dart';
import 'package:flutter/services.dart';
import 'package:workcheckin/views/register_screen.dart';
import 'package:workcheckin/models/size_config.dart';

import 'home_screen.dart';

final String _kanit = 'kanit';
AlertStyle alertStyle = AlertStyle(
  titleStyle: TextStyle(
    fontFamily: _kanit,
  ),
);
AlertType alertType;

class SigninScreen extends StatefulWidget {
  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool securePWD = true;
  var userMsg;
  SharedPreferences sharedPreferences;
  var locationlist;
  var msg;
  bool visible;
  var userID;
  String _deviceid = 'Unknown';
  var appVersion;

  showPWD() {
    if (securePWD) {
      setState(() {
        securePWD = false;
      });
    } else {
      setState(() {
        securePWD = true;
      });
    }
  }

  Future _login() async {
    if (_formKey.currentState.validate()) {
      setState(() => visible = true);
      String user = _username.text.trim();
      String pass = _password.text;

      try {
        setState(() => visible = true);
        // todo process login
        var url = 'http://159.138.232.139/service/cwi/v1/user/login';
        var data = {'username': user, 'password': pass};
        var response = await http.post(
          url,
          body: json.encode(data),
          headers: {
            "Authorization": "Basic bWluZGFvbm91YjpidTBuMEByQGRyZWU=",
            "Content-Type": "application/json"
          },
        );
        Map<String, dynamic> message = jsonDecode(response.body);
        sharedPreferences = await SharedPreferences.getInstance();
        var msgCode = message['responseCode'];
        setState(() => locationlist = message);
        setState(() {
          sharedPreferences.setString('userMsg', jsonEncode(message));
          sharedPreferences.setString('userData', jsonEncode(data));
          visible = false;
        });

        // if resCode == 000 => OK
        if (msgCode == '000') {
          setState(() => visible = false);
          // Check approveFlag
          if (message['cwiUser']['changeDeviceFlag'].toString() == '0') {
            setState(() {
              sharedPreferences.setInt('loginFlag', 1);
              visible = false;
            });

            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          } else {
            setState(() => visible = false);
            // Alert Change DeviceID
            Alert(
              context: context,
              type: AlertType.warning,
              title: "คุณต้องการเปลี่ยนโทรศัพท์ใช่หรือไม่ ?",
              style: alertStyle,
              desc: "",
              buttons: [
                DialogButton(
                  child: Text(
                    "ใช่",
                    style: TextStyle(
                        fontFamily: _kanit, color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () async {
                    var changdvid = await _changeDeviceID();
                    if (changdvid['responseCode'] == '000') {
                      sharedPreferences.setInt('loginFlag', 1);
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen()));
                    } else {
                      sharedPreferences.clear();
                      Alert(
                        context: context,
                        type: AlertType.error,
                        style: alertStyle,
                        title: changdvid['responseDesc'].toString(),
                        desc: '',
                        buttons: [
                          DialogButton(
                            child: Text(
                              "ตกลง",
                              style: TextStyle(
                                  fontFamily: _kanit,
                                  color: Colors.white,
                                  fontSize: 20),
                            ),
                            onPressed: () => Navigator.pop(context),
                            width: 120,
                          )
                        ],
                      ).show();
                    }
                  },
                  color: Color.fromRGBO(0, 179, 134, 1.0),
                ),
                DialogButton(
                  child: Text(
                    "ไม่ใช่",
                    style: TextStyle(
                        fontFamily: _kanit, color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () {
                    sharedPreferences.clear();
                    Navigator.pop(context);
                  },
                  gradient: LinearGradient(colors: [
                    Color.fromRGBO(116, 116, 191, 1.0),
                    Color.fromRGBO(52, 138, 199, 1.0)
                  ]),
                )
              ],
            ).show();
          }
        } else {
          // ResCode != 000 => cannot login
          setState(() => visible = false);

          Alert(
            context: context,
            type: AlertType.error,
            title: message['responseDesc'].toString(),
            desc: '',
            style: alertStyle,
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
      } catch (e) {
        debugPrint('login Err: $e');
      }
    }
  }

  Future<void> initDeviceId() async {
    String deviceid;

    deviceid = await DeviceId.getID;
    try {
      // todo
    } on PlatformException catch (e) {
      debugPrint('DeviceID Err: $e');
    }

    if (!mounted) return;

    setState(() {
      _deviceid = '$deviceid';
    });
  }

  Future _changeDeviceID() async {
    userID = locationlist['cwiUser']['modelid'];
    var url = 'http://159.138.232.139/service/cwi/v1/user/change_device_id';
    var data = {"userId": userID, "deviceId": _deviceid};

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
      return message;
    } else {
      return message;
    }
  }

  _signup() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => RegisterScreen()));
  }

  _getAppVersion() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      appVersion = sharedPreferences.getString('app_version');
    });
  }

  @override
  void initState() {
    super.initState();
    visible = false;
    initDeviceId();
    _getAppVersion();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var sizeHor = SizeConfig.safeBlockHorizontal;
    var sizeVer = SizeConfig.safeBlockVertical;
    return SafeArea(
      child: Scaffold(
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
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: sizeHor * 55,
                    child: Image.asset(
                      'assets/images/logos.png',
                      alignment: Alignment.center,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 60.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height / 12.0,
                                child: Image.asset(
                                  'assets/images/tot.png',
                                  alignment: Alignment.topRight,
                                ),
                              ),
                              Column(
                                children: <Widget>[
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              36.0),
                                  Form(
                                    key: _formKey,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: sizeHor * 6,
                                              right: sizeHor * 6),
                                          child: TextFormField(
                                            validator: (value) => value.length <
                                                    3
                                                ? 'username must more than 3 character'
                                                : null,
                                            style: TextStyle(
                                              color: Colors.black45,
                                            ),
                                            controller: _username,
                                            decoration: InputDecoration(
                                              labelText: 'username',
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.transparent),
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                              ),
                                              prefixIcon: Icon(
                                                Icons.person,
                                                color: Colors.grey,
                                              ),
                                              filled: true,
                                              fillColor: Color.alphaBlend(
                                                Colors.blue.withOpacity(.09),
                                                Colors.grey.withOpacity(.04),
                                              ),
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.red,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.blue,
                                                    width: 1.5),
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: sizeVer * 2),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: sizeHor * 6,
                                              right: sizeHor * 6),
                                          child: TextFormField(
                                            obscureText: securePWD,
                                            validator: (value) => value.length <
                                                    3
                                                ? 'password must more than 3 character'
                                                : null,
                                            style: TextStyle(
                                              color: Colors.black45,
                                            ),
                                            controller: _password,
                                            decoration: InputDecoration(
                                              suffixIcon: IconButton(
                                                onPressed: showPWD,
                                                icon: securePWD
                                                    ? Icon(Icons.visibility)
                                                    : Icon(
                                                        Icons.visibility_off),
                                              ),
                                              labelText: 'password',
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.transparent),
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                              ),
                                              prefixIcon: Icon(
                                                Icons.lock,
                                                color: Colors.grey,
                                              ),
                                              filled: true,
                                              fillColor: Color.alphaBlend(
                                                Colors.blue.withOpacity(.09),
                                                Colors.grey.withOpacity(.04),
                                              ),
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.red,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.blue,
                                                    width: 1.5),
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: sizeVer * 2),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: sizeHor * 6),
                                          child: RaisedButton(
                                            padding: EdgeInsets.symmetric(
                                                vertical: sizeVer * 1.6),
                                            child: Text(
                                              'เข้าสู่ระบบ',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: _kanit,
                                                fontSize: sizeHor * 2.5,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            elevation: 10,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            color: Colors.blue[400],
                                            onPressed: _login,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: sizeHor * 8),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              right: sizeHor * 6),
                                          child: RaisedButton(
                                            padding: EdgeInsets.symmetric(
                                                vertical: sizeVer * 1.6),
                                            child: Text(
                                              'สมัครสมาชิก',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: _kanit,
                                                fontSize: sizeHor * 2.5,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            elevation: 10,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            color: Colors.blue[400],
                                            onPressed: _signup,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 5.5,
                  ),
                ],
              ),
            ),
            Center(
              child: Visibility(
                  visible: visible, child: CircularProgressIndicator()),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        'Version $appVersion',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontFamily: _kanit,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
