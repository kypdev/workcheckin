import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

final _kanit = 'Kanit';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  SharedPreferences sharedPreferences;
  var message;
  getMsg() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var msg = jsonDecode(sharedPreferences.getString('userMsg'));
    setState(() {
      message = msg;
    });
    print(message['cwiUser']['orgId']);
  }

  @override
  void initState() {
    getMsg();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ข้อมูลส่วนตัว',
          style: TextStyle(fontFamily: _kanit),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'องค์กร : ' + message['cwiUser']['orgId'].toString(),
                            style: TextStyle(
                              fontFamily: _kanit,
                              fontSize: 18.0,
                            ),
                          ),
                          Text(
                            'สาขา : ' +
                                message['cwiUser']['branchId'].toString(),
                            style: TextStyle(
                              fontFamily: _kanit,
                              fontSize: 18.0,
                            ),
                          ),
                          Text(
                            'Username : ' +
                                message['cwiUser']['username'].toString(),
                            style: TextStyle(
                              fontFamily: _kanit,
                              fontSize: 18.0,
                            ),
                          ),
                          Text(
                            'ชื่อ : ' + message['cwiUser']['name'].toString() + ' ' +  message['cwiUser']['lastname'].toString(),
                            style: TextStyle(
                              fontFamily: _kanit,
                              fontSize: 18.0,
                            ),
                          ),
                         
                         Text(
                            'รหัสพนักงาน : ' +
                                message['cwiUser']['employeeId'].toString(),
                            style: TextStyle(
                              fontFamily: _kanit,
                              fontSize: 18.0,
                            ),
                          ),
                          Text(
                            'ตำแหน่ง : ' +
                                message['cwiUser']['position'].toString(),
                            style: TextStyle(
                              fontFamily: _kanit,
                              fontSize: 18.0,
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                'หัวหน้า : ',
                            style: TextStyle(
                              fontFamily: _kanit,
                              fontSize: 18.0,
                            ),
                          ),
                              Text(
                                    message['cwiUser']['bossId'].toString() == '0'? '': message['cwiUser']['bossId'].toString(),
                                style: TextStyle(
                                  fontFamily: _kanit,
                                  fontSize: 18.0,
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
            ),
          ),
        ],
      ),
    );
  }
}
