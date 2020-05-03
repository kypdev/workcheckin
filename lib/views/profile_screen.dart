import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

final _kanit = 'Kanit';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  SharedPreferences sharedPreferences;
  var message;
  var resProfile;
  getMsg() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var msg = await jsonDecode(sharedPreferences.getString('userMsg'));

    var userID = msg['cwiUser']['modelid'].toString();
    var url = 'http://159.138.232.139/service/cwi/v1/user/get_profile';
    var data = {"userId": userID};
    var response = await http.post(
      url,
      body: jsonEncode(data),
      headers: {
        "Authorization": "Basic bWluZGFvbm91YjpidTBuMEByQGRyZWU=",
        "Content-Type": "application/json"
      },
    );
    Map<String, dynamic> messages = jsonDecode(response.body);
    setState(() {
      resProfile = messages;
    });
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
      body: Stack(
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
              children: <Widget>[
                resProfile == null
                    ? Center(
                        child: Visibility(
                          visible: true,
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Padding(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'องค์กร : ' +
                                            resProfile['cwiUser']['orgName']
                                                .toString(),
                                        style: TextStyle(
                                          fontFamily: _kanit,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                      Text(
                                        'สาขา : ' +
                                            resProfile['cwiUser']['branchName']
                                                .toString(),
                                        style: TextStyle(
                                          fontFamily: _kanit,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                      Text(
                                        'Username : ' +
                                            resProfile['cwiUser']['username']
                                                .toString(),
                                        style: TextStyle(
                                          fontFamily: _kanit,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                      Text(
                                        'ชื่อ : ' +
                                            resProfile['cwiUser']['name']
                                                .toString() +
                                            ' ' +
                                            resProfile['cwiUser']['lastname']
                                                .toString(),
                                        style: TextStyle(
                                          fontFamily: _kanit,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                      Text(
                                        'รหัสพนักงาน : ' +
                                            resProfile['cwiUser']['employeeId']
                                                .toString(),
                                        style: TextStyle(
                                          fontFamily: _kanit,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                      // Text(
                                      //   'ตำแหน่ง : ' + resProfile['cwiUser']['position'].toString(),
                                      //   style: TextStyle(
                                      //     fontFamily: _kanit,
                                      //     fontSize: 18.0,
                                      //   ),
                                      // ),
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
                                            resProfile['cwiUser']['bossId']
                                                        .toString() ==
                                                    '0'
                                                ? ''
                                                : resProfile['cwiUser']
                                                        ['bossName']
                                                    .toString(),
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
          ),
        ],
      ),
    );
  }
}
