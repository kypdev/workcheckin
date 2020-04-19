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
                            'Org : ' + message['cwiUser']['orgId'].toString(),
                            style: TextStyle(
                              fontFamily: _kanit,
                              fontSize: 13.0,
                            ),
                          ),
                          Text(
                            'Branch : ' +
                                message['cwiUser']['branchId'].toString(),
                            style: TextStyle(
                              fontFamily: _kanit,
                              fontSize: 13.0,
                            ),
                          ),
                          Text(
                            'Branch : ' +
                                message['cwiUser']['username'].toString(),
                            style: TextStyle(
                              fontFamily: _kanit,
                              fontSize: 13.0,
                            ),
                          ),
                          Text(
                            'Branch : ' + message['cwiUser']['name'].toString(),
                            style: TextStyle(
                              fontFamily: _kanit,
                              fontSize: 13.0,
                            ),
                          ),
                          Text(
                            'Branch : ' +
                                message['cwiUser']['lastname'].toString(),
                            style: TextStyle(
                              fontFamily: _kanit,
                              fontSize: 13.0,
                            ),
                          ),
                          Text(
                            'Branch : ' +
                                message['cwiUser']['position'].toString(),
                            style: TextStyle(
                              fontFamily: _kanit,
                              fontSize: 13.0,
                            ),
                          ),
                          Text(
                            'Branch : ' +
                                message['cwiUser']['bossId'].toString(),
                            style: TextStyle(
                              fontFamily: _kanit,
                              fontSize: 13.0,
                            ),
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
