import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  final _formKey = GlobalKey<FormState>();
  bool obpass, obconpass;
  var org = '';
  List<dynamic> orgData;
  List<String> orgItem = [];
  int indexOrd;
  var resOrgList;
  var ordId;
  List<dynamic> branchData;
  List<String> branchItem = [];
  int branchIndex;
  var branchName;
  var position;
  var resBranshlist;
  var branchid;

  _getOrg() async {
    var url = 'http://159.138.232.139/service/cwi/v1/master/getOrgList';

    var response = await http.post(
      url,
      body: '{}',
      headers: {"Authorization": "Basic bWluZGFvbm91YjpidTBuMEByQGRyZWU=", "Content-Type": "application/json"},
    );
    Map<String, dynamic> messages = jsonDecode(response.body);
    var msg = messages;
    setState(() => indexOrd = 0);
    setState(() => resOrgList = messages);
    orgData = msg['orgList'];

    for (int i = 0; i < orgData.length; i++) {
      for (int j = i; j <= i; j++) {
        orgItem.add(orgData[i]['name']);
      }
    }
    print(orgItem);
    _getBranch();
  }

  _getBranch() async {
    var url = 'http://159.138.232.139/service/cwi/v1/master/getBranchList';
    var data = {'orgId': ordId};
    var response = await http.post(
      url,
      body: jsonEncode(data),
      headers: {"Authorization": "Basic bWluZGFvbm91YjpidTBuMEByQGRyZWU=", "Content-Type": "application/json"},
    );
    print(branchItem);
    Map<String, dynamic> messages = jsonDecode(response.body);
    setState(() => resBranshlist = messages);
    setState(() => branchIndex = 0);
    setState(() => branchName = 0);
    branchData = resBranshlist['branchList'];
    branchItem.clear();

    for (int i = 0; i < branchData.length; i++) {
      for (int j = i; j <= i; j++) {
        branchItem.add(branchData[i]['name']);
      }
    }

    print('$branchItem');
  }

  _cleardata() {
    branchItem.clear();
    print('$branchItem');
    branchItem.add('');
    _getBranch();
  }

  _register() {
    if (_formKey.currentState.validate()) {}
  }

  @override
  void initState() {
    obconpass = true;
    obpass = true;
    super.initState();
    _getOrg();
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
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              RaisedButton(
                child: Text('test'),
                onPressed: () {
                  _getBranch();
                },
              ),
              RaisedButton(
                child: Text('test2'),
                onPressed: () {
                  _cleardata();
                },
              ),
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
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: indexOrd == null ? null : orgItem[indexOrd],
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
                              indexOrd = orgItem.indexOf(value);
                              org = resOrgList['orgList'][indexOrd]['name'];
                              ordId = resOrgList['orgList'][indexOrd]['modelid'];
                            });
                            print('$indexOrd, $org $ordId');
                            _cleardata();
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
                          value: branchIndex == null ? null : branchItem[branchIndex],
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
                              branchName = resBranshlist['branchList'][branchIndex]['name'].toString();
                              branchid = resBranshlist['branchList'][branchIndex]['modelid'].toString();
                              print('$branchName, $branchid');
                            });
                          },
                        ),
                      ),
                      form(
                        visible: false,
                        ctrl: usernameCtrl,
                        labeltext: 'Username',
                        prefixicon: Icon(Icons.person),
                        val: (value) {
                          if (value.isEmpty || value.length < 5) {
                            return 'ชื่อผู้ใช้ ห้ามว่าง หรือ ต่ำกว่า 6 ตัวอักษร';
                          }
                          return null;
                        },
                      ),
                      form(
                        visible: obpass,
                        ctrl: passwordCtrl,
                        labeltext: 'รหัสผ่าน',
                        prefixicon: Icon(Icons.lock),
                        sufficicon: IconButton(
                          icon: obpass ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
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
                          icon: obconpass ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
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
                    ],
                  ),
                ),
              ),
              RaisedButton(
                color: Colors.blue,
                child: Text(
                  'สมัครสมาชิก',
                  style: TextStyle(
                    fontFamily: _kanit,
                    color: Colors.white,
                  ),
                ),
                onPressed: _register,
              ),
            ],
          ),
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

// #####################################################

// class widgetregister extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Scaffold(
//         appBar: AppBar(
//           title: Text(
//             'สมัครสมาชิก',
//             style: TextStyle(fontFamily: _kanit),
//           ),
//           centerTitle: true,
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             children: <Widget>[
//               Form(
//                 key: _formKey,
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 20, right: 20),
//                   child: Column(
//                     children: <Widget>[
//                       dropdown(
//                         value: org,
//                         title: 'องค์กร',
//                       ),
//                       dropdown(
//                         value: org,
//                         title: 'สาขา',
//                       ),
//                       form(
//                         visible: false,
//                         ctrl: usernameCtrl,
//                         labeltext: 'Username',
//                         prefixicon: Icon(Icons.person),
//                         val: (value) {
//                           if (value.isEmpty || value.length < 5) {
//                             return 'ชื่อผู้ใช้ ห้ามว่าง หรือ ต่ำกว่า 6 ตัวอักษร';
//                           }
//                           return null;
//                         },
//                       ),
//                       form(
//                         visible: obpass,
//                         ctrl: passwordCtrl,
//                         labeltext: 'รหัสผ่าน',
//                         prefixicon: Icon(Icons.lock),
//                         sufficicon: IconButton(
//                           icon: obpass
//                               ? Icon(Icons.visibility)
//                               : Icon(Icons.visibility_off),
//                           onPressed: () {
//                             if (obpass) {
//                               setState(() {
//                                 obpass = false;
//                               });
//                             } else {
//                               setState(() {
//                                 obpass = true;
//                               });
//                             }
//                           },
//                         ),
//                         val: (value) {
//                           if (value.isEmpty || value.length < 5) {
//                             return 'รหัสผ่าน ห้ามว่าง หรือ ต่ำกว่า 6 ตัวอักษร';
//                           }
//                           return null;
//                         },
//                       ),
//                       form(
//                         visible: obconpass,
//                         ctrl: conPasswordCtrl,
//                         labeltext: 'ยืนยันรหัสผ่าน',
//                         prefixicon: Icon(Icons.lock),
//                         sufficicon: IconButton(
//                           icon: obconpass
//                               ? Icon(Icons.visibility)
//                               : Icon(Icons.visibility_off),
//                           onPressed: () {
//                             if (obconpass) {
//                               setState(() {
//                                 obconpass = false;
//                               });
//                             } else {
//                               setState(() {
//                                 obconpass = true;
//                               });
//                             }
//                           },
//                         ),
//                         val: (value) {
//                           if (value.isEmpty || value.length < 5) {
//                             return 'รหัสผ่าน ห้ามว่าง หรือ ต่ำกว่า 6 ตัวอักษร';
//                           }
//                           return null;
//                         },
//                       ),
//                       form(
//                         visible: false,
//                         ctrl: nameCtrl,
//                         labeltext: 'ชื่อ',
//                         prefixicon: Icon(Icons.person),
//                         val: (value) {
//                           if (value.isEmpty) {
//                             return 'ชื่อ ห้ามว่าง';
//                           }
//                           return null;
//                         },
//                       ),
//                       form(
//                         visible: false,
//                         ctrl: lastnameCtrl,
//                         labeltext: 'นามสกุล',
//                         prefixicon: Icon(Icons.person),
//                         val: (value) {
//                           if (value.isEmpty) {
//                             return 'นามสกุล ห้ามว่าง';
//                           }
//                           return null;
//                         },
//                       ),
//                       form(
//                         visible: false,
//                         ctrl: positionCtrl,
//                         labeltext: 'ตำแหน่ง',
//                         prefixicon: Icon(Icons.person),
//                         val: (value) {
//                           if (value.isEmpty) {
//                             return 'ตำแหน่ง ห้ามว่าง';
//                           }
//                           return null;
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               RaisedButton(
//                 color: Colors.blue,
//                 child: Text(
//                   'สมัครสมาชิก',
//                   style: TextStyle(
//                     fontFamily: _kanit,
//                     color: Colors.white,
//                   ),
//                 ),
//                 onPressed: _register,
//               ),
//               RaisedButton(
//                 child: Text('asdf'),
//                 onPressed: _showBranchModal,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget form({
//     ctrl,
//     labeltext,
//     prefixicon,
//     val,
//     sufficicon,
//     visible,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 20),
//       child: TextFormField(
//         obscureText: visible,
//         validator: val,
//         controller: ctrl,
//         decoration: InputDecoration(
//           labelText: labeltext,
//           prefixIcon: prefixicon,
//           fillColor: Colors.black12.withOpacity(0.059),
//           filled: true,
//           enabledBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: Colors.transparent),
//             borderRadius: BorderRadius.circular(100),
//           ),
//           border: OutlineInputBorder(
//             borderSide: BorderSide(
//               color: Colors.red,
//             ),
//             borderRadius: BorderRadius.circular(100),
//           ),
//           suffixIcon: sufficicon,
//         ),
//       ),
//     );
//   }

//   Widget dropdown({
//     value,
//     title,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 20, top: 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Text(
//             title,
//             style: TextStyle(
//               fontFamily: _kanit,
//               fontSize: 20.0,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: <Widget>[
//               Text(
//                 value,
//                 style: TextStyle(
//                   fontFamily: _kanit,
//                   fontSize: 18.0,
//                 ),
//               ),
//               Icon(
//                 Icons.arrow_drop_down,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
