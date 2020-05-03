import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:device_id/device_id.dart';
import 'package:workcheckin/views/signin_screen.dart';

final _kanit = 'Kanit';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController usernameCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  TextEditingController conPasswordCtrl = TextEditingController();
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController lastnameCtrl = TextEditingController();
  TextEditingController positionCtrl = TextEditingController();
  TextEditingController employeeCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool obpass, obconpass;
  var org = '';
  List<dynamic> orgData;
  List<String> orgItem = [];
  int indexOrg;
  var resOrgList;
  var orgId = 3;
  List<dynamic> branchData;
  List<String> branchItem = [];
  int branchIndex;
  var branchName;
  var position;
  var resBranshlist;
  var branchid;
  List<dynamic> bossData;
  List<String> bossItem = [];
  int bossIndexDD;
  var bossName;
  var resBossList;
  var bossId;
  List<dynamic> positionData;
  List<String> positionItem = [];
  int positionIndexDD;
  var positionName;
  var resPositionList;
  var positionId;
  bool visible;
  var orgShortname;
  String _deviceid = 'Unknown';

  _getOrg() async {
    var url = 'http://159.138.232.139/service/cwi/v1/master/getOrgList';
    var response = await http.post(
      url,
      body: '{}',
      headers: {
        "Authorization": "Basic bWluZGFvbm91YjpidTBuMEByQGRyZWU=",
        "Content-Type": "application/json"
      },
    );
    Map<String, dynamic> messages = jsonDecode(response.body);
    var msg = messages;
    setState(() => indexOrg = 0);
    setState(() => resOrgList = messages);
    setState(() => orgId = msg['orgList'][0]['modelid']);
    setState(() => orgShortname = msg['orgList'][0]['shortName']);
    orgData = msg['orgList'];

    for (int i = 0; i < orgData.length; i++) {
      for (int j = i; j <= i; j++) {
        orgItem.add(orgData[i]['name']);
      }
    }
    _getBranch();
  }

  _getBranch() async {
    try {
      var url =
          'http://159.138.232.139/service/cwi/v1/master/get_branch_list_for_org';
      var data = {'orgId': orgId};
      var response = await http.post(
        url,
        body: jsonEncode(data),
        headers: {
          "Authorization": "Basic bWluZGFvbm91YjpidTBuMEByQGRyZWU=",
          "Content-Type": "application/json"
        },
      );
      Map<String, dynamic> messages = jsonDecode(response.body);
      setState(() => resBranshlist = messages);
      setState(() => branchIndex = 0);
      setState(() => branchName = '');
      setState(() => branchid = messages['branchList'][0]['modelid']);
      branchData = resBranshlist['branchList'];
      branchItem = [];

      for (int i = 0; i < branchData.length; i++) {
        for (int j = i; j <= i; j++) {
          branchItem.add(branchData[i]['name']);
        }
      }
    } catch (e) {
      debugPrint('ErrBrch: $e');
    }
  }

  _getBossList() async {
    try {
      var url = 'http://159.138.232.139/service/cwi/v1/master/getBossList?';
      var data = {'orgId': orgId};
      var response = await http.post(
        url,
        body: jsonEncode(data),
        headers: {
          "Authorization": "Basic bWluZGFvbm91YjpidTBuMEByQGRyZWU=",
          "Content-Type": "application/json"
        },
      );

      Map<String, dynamic> messages = jsonDecode(response.body);
      setState(() => resBossList = messages);
      setState(() => bossIndexDD = 0);
      setState(() => bossName = '');
      setState(() => bossData = messages['bossList']);
      setState(() => bossId = messages['bossList'][0]['modelid']);
      setState(() => bossItem = []);

      if (resBossList['bossList'].isEmpty) {
        bossItem.add('ไม่พบข้อมูล');
      } else {
        setState(() => bossItem = []);
        for (int i = 0; i < bossData.length; i++) {
          for (int j = i; j <= i; j++) {
            bossItem.add(bossData[i]['name']);
          }
        }
      }
    } catch (e) {
      debugPrint('ErrBossList: ${e.message}');
    }
  }

  _getPositionList() {
    positionItem = ["พนักงาน"];
    setState(() {
      positionIndexDD = 0;
      positionId = '3';
    });
  }

  Future<void> initDeviceId() async {
    String deviceid;
    deviceid = await DeviceId.getID;
    try {
      // todo
    } on PlatformException catch (e) {
      debugPrint('ErrDeviceID: ${e.message}');
    }

    if (!mounted) return;

    setState(() => _deviceid = '$deviceid');
  }

  _register() async {
    String username = usernameCtrl.text.trim();
    String passwords = passwordCtrl.text;
    String conpasswords = conPasswordCtrl.text;
    String firstname = nameCtrl.text.trim();
    String lastname = lastnameCtrl.text.trim();
    String employeeid = employeeCtrl.text.trim();

    if (_formKey.currentState.validate()) {
      if (passwords != conpasswords) {
        Alert(
          context: context,
          type: AlertType.warning,
          title: "รหัสผ่านไม่ตรงกันกรุณาตรวจสอบ",
          desc: "",
          buttons: [
            DialogButton(
              child: Text(
                "ตกลง",
                style: TextStyle(
                    fontFamily: _kanit, color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              color: Colors.red,
            )
          ],
        ).show();
      } else {
        setState(() => visible = false);
        var usr = username + '@' + orgShortname.toString();
        var data = {
          "employeeId": employeeid,
          "username": usr,
          "password": passwords,
          "passwordConfirm": conpasswords,
          "name": firstname,
          "lastname": lastname,
          "position": positionId,
          "orgId": orgId,
          "branchId": branchid,
          "status": 0,
          "bossId": bossId,
          "deviceId": _deviceid
        };
        var url = 'http://159.138.232.139/service/cwi/v1/user/register';
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
          setState(() => visible = false);
          Alert(
            context: context,
            type: AlertType.warning,
            title: 'บันทึกสำเร็จ',
            desc: "",
            buttons: [
              DialogButton(
                child: Text(
                  "ตกลง",
                  style: TextStyle(
                      fontFamily: _kanit, color: Colors.white, fontSize: 20),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => SigninScreen()));
                },
                color: Colors.green,
              )
            ],
          ).show();
        } else {
          setState(() => visible = false);
          Alert(
            context: context,
            type: AlertType.warning,
            title: message['responseDesc'].toString(),
            desc: "",
            buttons: [
              DialogButton(
                child: Text(
                  "ตกลง",
                  style: TextStyle(
                      fontFamily: _kanit, color: Colors.white, fontSize: 20),
                ),
                onPressed: () => Navigator.pop(context),
                color: Colors.red,
              )
            ],
          ).show();
        }
      }
    }
  }

  @override
  void initState() {
    obconpass = true;
    obpass = true;
    super.initState();
    _getOrg();
    _getPositionList();
    _getBossList();
    initDeviceId();
    visible = false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'สมัครสมาชิก',
            style: TextStyle(fontFamily: _kanit),
          ),
          centerTitle: true,
        ),
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
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          dropdown(
                            title: 'องค์กร',
                          ),
                          // org dropdown
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value:
                                  indexOrg == null ? null : orgItem[indexOrg],
                              items: orgItem.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(fontFamily: _kanit),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  // get index
                                  indexOrg = orgItem.indexOf(value);

                                  org = resOrgList['orgList'][indexOrg]['name'];
                                  orgId = resOrgList['orgList'][indexOrg]
                                      ['modelid'];

                                  branchid = '';
                                  bossId = '';
                                });
                                _getBranch();
                                _getBossList();
                              },
                            ),
                          ),
                          dropdown(
                            title: 'สาขา',
                          ),

                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: branchIndex == null
                                  ? null
                                  : branchItem[branchIndex],
                              items: branchItem.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(fontFamily: _kanit),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  // get index
                                  branchIndex = branchItem.indexOf(value);
                                  branchName = resBranshlist['branchList']
                                          [branchIndex]['name']
                                      .toString();
                                  branchid = resBranshlist['branchList']
                                          [branchIndex]['modelid']
                                      .toString();
                                });
                              },
                            ),
                          ),

                          form(
                            visible: false,
                            ctrl: employeeCtrl,
                            labeltext: 'employee id',
                            prefixicon: Icon(Icons.vpn_key),
                            val: (value) {
                              if (value.isEmpty || value.length < 4) {
                                return 'รหัสพนักงานห้มต่ำกว่า 5 ตัวอักษร';
                              }
                              return null;
                            },
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: TextFormField(
                              obscureText: false,
                              validator: (value) {
                                if (value.isEmpty || value.length < 5) {
                                  return 'ชื่อผู้ใช้ ห้ามว่าง หรือ ต่ำกว่า 6 ตัวอักษร';
                                }
                                return null;
                              },
                              controller: usernameCtrl,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person),
                                suffix: Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: Text('@' + orgShortname.toString()),
                                ),
                                labelText: 'Username',
                                fillColor: Colors.black12.withOpacity(0.059),
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                  ),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                            ),
                          ),

                          form(
                            visible: obpass,
                            ctrl: passwordCtrl,
                            labeltext: 'รหัสผ่าน',
                            prefixicon: Icon(Icons.lock),
                            sufficicon: IconButton(
                              icon: obpass
                                  ? Icon(Icons.visibility)
                                  : Icon(Icons.visibility_off),
                              onPressed: () {
                                if (obpass) {
                                  setState(() {
                                    obpass = false;
                                  });
                                } else {
                                  setState(() {
                                    obpass = true;
                                  });
                                }
                              },
                            ),
                            val: (value) {
                              if (value.isEmpty || value.length < 5) {
                                return 'รหัสผ่าน ห้ามว่าง หรือ ต่ำกว่า 6 ตัวอักษร';
                              }
                              return null;
                            },
                          ),
                          form(
                            visible: obconpass,
                            ctrl: conPasswordCtrl,
                            labeltext: 'ยืนยันรหัสผ่าน',
                            prefixicon: Icon(Icons.lock),
                            sufficicon: IconButton(
                              icon: obconpass
                                  ? Icon(Icons.visibility)
                                  : Icon(Icons.visibility_off),
                              onPressed: () {
                                if (obconpass) {
                                  setState(() {
                                    obconpass = false;
                                  });
                                } else {
                                  setState(() {
                                    obconpass = true;
                                  });
                                }
                              },
                            ),
                            val: (value) {
                              if (value.isEmpty || value.length < 5) {
                                return 'รหัสผ่าน ห้ามว่าง หรือ ต่ำกว่า 6 ตัวอักษร';
                              }
                              return null;
                            },
                          ),
                          form(
                            visible: false,
                            ctrl: nameCtrl,
                            labeltext: 'ชื่อ',
                            prefixicon: Icon(Icons.person),
                            val: (value) {
                              if (value.isEmpty) {
                                return 'ชื่อ ห้ามว่าง';
                              }
                              return null;
                            },
                          ),
                          form(
                            visible: false,
                            ctrl: lastnameCtrl,
                            labeltext: 'นามสกุล',
                            prefixicon: Icon(Icons.person),
                            val: (value) {
                              if (value.isEmpty) {
                                return 'นามสกุล ห้ามว่าง';
                              }
                              return null;
                            },
                          ),
                          dropdown(
                            title: 'ตำแหน่ง',
                          ),

                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: positionIndexDD == null
                                  ? null
                                  : positionItem[positionIndexDD],
                              items: positionItem.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(fontFamily: _kanit),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  positionIndexDD = positionItem.indexOf(value);
                                  if (positionIndexDD == 0) {
                                    positionId = 3;
                                  } else if (positionIndexDD == 1) {
                                    positionId = 2;
                                  } else {
                                    positionId = 1;
                                  }
                                });
                              },
                            ),
                          ),

                          dropdown(
                            title: 'หัวหน้า',
                          ),

                          // boss dropdown
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: bossIndexDD == null
                                  ? null
                                  : bossItem[bossIndexDD],
                              items: bossItem.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(fontFamily: _kanit),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  bossIndexDD = bossItem.indexOf(value);
                                  bossId = resBossList['bossList'][bossIndexDD]
                                          ['modelid']
                                      .toString();
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 30, right: 30, top: 20, bottom: 20),
                    child: RaisedButton(
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      color: Color(0xff07395A).withOpacity(0.79),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 15,
                        child: Center(
                          child: Text(
                            'สมัครสมาชิก',
                            style: TextStyle(
                              fontFamily: _kanit,
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      onPressed: _register,
                    ),
                  ),
                ],
              ),
            ),
            Center(
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

  Widget form({
    ctrl,
    labeltext,
    prefixicon,
    val,
    sufficicon,
    visible,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: TextFormField(
        obscureText: visible,
        validator: val,
        controller: ctrl,
        decoration: InputDecoration(
          labelText: labeltext,
          prefixIcon: prefixicon,
          fillColor: Colors.black12.withOpacity(0.059),
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(100),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
            ),
            borderRadius: BorderRadius.circular(100),
          ),
          suffixIcon: sufficicon,
        ),
      ),
    );
  }

  Widget dropdown({
    title,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontFamily: _kanit,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
