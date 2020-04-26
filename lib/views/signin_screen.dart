import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workcheckin/views/home_screen.dart';
import 'package:device_id/device_id.dart';
import 'package:flutter/services.dart';
import 'package:workcheckin/views/register_screen.dart';

final String _kanit = 'kanit';

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

  getUserMsg() {
    var msg = sharedPreferences.getString('userMsg');
    print('pref: $msg');
  }

  Future _login() async {
    if (_formKey.currentState.validate()) {
      setState(() => visible = true);
      String user = _username.text.trim();
      String pass = _password.text;

      try {
        var url = 'http://159.138.232.139/service/cwi/v1/user/login';
        var data = {'username': user, 'password': pass};

        var response = await http.post(
          url,
          body: json.encode(data),
          headers: {"Authorization": "Basic bWluZGFvbm91YjpidTBuMEByQGRyZWU=", "Content-Type": "application/json"},
        );

        Map<String, dynamic> message = jsonDecode(response.body);
        var userData;
        sharedPreferences = await SharedPreferences.getInstance();
        setState(() {});

        var msg = message['responseCode'];
        setState(() {
          locationlist = message;
        });
        print(message);
        setState(() {
          sharedPreferences.setString('userMsg', jsonEncode(message));
          userData = sharedPreferences.setString('userData', jsonEncode(data));

          visible = false;
        });

        if (msg == '000') {
          if (message['cwiUser']['changeDeviceFlag'] == 0) {
            setState(() {
              sharedPreferences.setInt('loginFlag', 1);
              visible = false;
            });
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
          } else {
            setState(() {
              visible = false;
            });
            Alert(
              context: context,
              type: AlertType.warning,
              title: "คุณต้องการเปลี่ยนโทรศัพท์ใช่หรือไม่ ?",
              desc: "",
              buttons: [
                DialogButton(
                  child: Text(
                    "ใช่",
                    style: TextStyle(fontFamily: _kanit, color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () async {
                    var changdvid = await _changeDeviceID();
                    print(changdvid);
                    if (changdvid['responseCode'] == '000') {
                      print('change ok');
                      sharedPreferences.setInt('loginFlag', 1);
                      print(sharedPreferences.getInt('loginFlag'));
                      Navigator.pop(context);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                    } else {
                      sharedPreferences.clear();
                      Alert(
                        context: context,
                        type: AlertType.error,
                        title: "",
                        desc: changdvid['responseDesc'].toString(),
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
                  },
                  color: Color.fromRGBO(0, 179, 134, 1.0),
                ),
                DialogButton(
                  child: Text(
                    "ไม่ใช่",
                    style: TextStyle(fontFamily: _kanit, color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () {
                    sharedPreferences.clear();
                    Navigator.pop(context);
                  },
                  gradient: LinearGradient(colors: [Color.fromRGBO(116, 116, 191, 1.0), Color.fromRGBO(52, 138, 199, 1.0)]),
                )
              ],
            ).show();
          }
        } else {
          print('error');
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
                  style: TextStyle(fontFamily: _kanit, color: Colors.white, fontSize: 20),
                ),
                onPressed: () => Navigator.pop(context),
                width: 120,
              )
            ],
          ).show();
        }
      } catch (e) {
        print('message error: $e');
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

  Future _changeDeviceID() async {
    userID = locationlist['cwiUser']['modelid'];
    var url = 'http://159.138.232.139/service/cwi/v1/user/change_device_id';
    var data = {"userId": userID, "deviceId": _deviceid};

    var response = await http.post(
      url,
      body: json.encode(data),
      headers: {"Authorization": "Basic bWluZGFvbm91YjpidTBuMEByQGRyZWU=", "Content-Type": "application/json"},
    );

    Map<String, dynamic> message = jsonDecode(response.body);

    print(message);

    if (message['responseCode'] == '000') {
      return message;
    } else {
      print('no change');
      return message;
    }
  }

  _signup() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
  }

  @override
  void initState() {
    super.initState();
    visible = false;
    initDeviceId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/images/login.jpg',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: MediaQuery.of(context).size.height/6,),
                  
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        children: <Widget>[
                          Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                                  child: TextFormField(
                                    validator: (value) => value.length < 3 ? 'username must more than 3 character' : null,
                                    style: TextStyle(
                                      color: Colors.black45,
                                    ),
                                    controller: _username,
                                    decoration: InputDecoration(
                                      labelText: 'username',
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.transparent),
                                        borderRadius: BorderRadius.circular(100),
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
                                        borderRadius: BorderRadius.circular(100),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.blue, width: 1.5),
                                        borderRadius: BorderRadius.circular(100),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                                  child: TextFormField(
                                    obscureText: securePWD,
                                    validator: (value) => value.length < 3 ? 'password must more than 3 character' : null,
                                    style: TextStyle(
                                      color: Colors.black45,
                                    ),
                                    controller: _password,
                                    decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                        onPressed: showPWD,
                                        icon: securePWD ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                                      ),
                                      labelText: 'password',
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.transparent),
                                        borderRadius: BorderRadius.circular(100),
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
                                        borderRadius: BorderRadius.circular(100),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.blue, width: 1.5),
                                        borderRadius: BorderRadius.circular(100),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: RaisedButton(
                                    child: Text(
                                      'เข้าสู่ระบบ',
                                      style: TextStyle(color: Colors.white, fontFamily: _kanit),
                                    ),
                                    elevation: 10,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    color: Colors.blue[400],
                                    onPressed: _login,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: RaisedButton(
                                    child: Text(
                                      'สมัครสมาชิก',
                                      style: TextStyle(color: Colors.white, fontFamily: _kanit),
                                    ),
                                    elevation: 10,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
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
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Visibility(visible: visible, child: CircularProgressIndicator()),
            ),
          ],
        ),
      ),
    );
  }
}
