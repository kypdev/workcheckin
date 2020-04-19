import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workcheckin/views/home_screen.dart';

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

  var locationlist;
  var msg;

  getUserMsg(){
    var msg = sharedPreferences.getString('userMsg');
    print('pref: $msg');
  }

  Future _login() async {
    String user = _username.text.trim();
    String pass = _password.text;

    try {
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
      setState(() {
        sharedPreferences.setString('userMsg', jsonEncode(message));
      });

      

      var msg = message['responseCode'];
      setState(() {
        locationlist = message;
      });

      if (msg == '000') {
        setState(() {
          sharedPreferences.setInt('loginFlag', 1);
        });
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen()));
      } else {
        print('error');
        Alert(
          context: context,
          type: AlertType.error,
          title: "",
          desc: "พบข้อผิดพลาดกรุณาทำรายการใหม่",
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
      print('message error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              color: Colors.blue,
            ),
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20),
                  Image.asset(
                    'assets/images/logo.png',
                    height: 200,
                  ),
                  SizedBox(height: 20),
                  // Text(
                  //   'ECORP',
                  //   style: TextStyle(fontSize: 50.0, color: Colors.white),
                  // ),
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
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 20),
                                  child: TextFormField(
                                    validator: (value) => value.length < 3
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
                                            color: Colors.blue, width: 1.5),
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 20),
                                  child: TextFormField(
                                    obscureText: securePWD,
                                    validator: (value) => value.length < 3
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
                                            : Icon(Icons.visibility_off),
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
                                            color: Colors.blue, width: 1.5),
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          RaisedButton(
                            child: Text(
                              'LOGIN',
                              style: TextStyle(color: Colors.white),
                            ),
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            color: Colors.blue[400],
                            onPressed: _login,
                          ),
                          SizedBox(height: 20),
                          
                        ],
                      ),
                    ),
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
