import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:workcheckin/models/branch_list.dart';

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
  var org = 'องค์การโทรศัพท์';
  List<BranchList> branchItem = [];
  int position = 1;

  _register() {
    if (_formKey.currentState.validate()) {}
  }

  Future<List<BranchList>> _getBrahch() async {

    var url = 'http://159.138.232.139/service/cwi/v1/master/getBranchList';
    var data = {"orgId": "1"};

    var response = await http.post(
      url,
      body: json.encode(data),
      headers: {
        "Authorization": "Basic bWluZGFvbm91YjpidTBuMEByQGRyZWU=",
        "Content-Type": "application/json"
      },
    );

    Map<String, dynamic> msg = jsonDecode(response.body);

    print(msg['branchList'][0]);

    List<BranchList> branchList = [];
    for (var bl in msg['branchList']) {
      BranchList branchLists = BranchList(
        bl['modelid'],
        bl['name'],
        bl['status'],
        bl['orgId'],
        bl['createDate'],
        bl['createBy'],
        bl['updateDate'],
        bl['updateBy'],
      );
      branchList.add(branchLists);
    }
      print(branchList);
    return branchList;
  }

  _showBranchModal() {
    
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context){
        return Container(
          child: FutureBuilder(
            future: _getBrahch(),
            builder: (BuildContext context, AsyncSnapshot sn){
              ListView.builder(
                itemCount: sn.data.length,
                itemBuilder: (BuildContext context, int index){
                  if(sn.data == null){
                    return Text('nodata');
                  }
                  return Text(
                    sn.data[index].modelid.toString(),
                  );
                },
              );
            }
          ),
        );
      },
    );
  }

  @override
  void initState() {
    obconpass = true;
    obpass = true;
    super.initState();
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
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: <Widget>[

                      dropdown(
                        value: org,
                        title: 'องค์กร',
                      ),

                      dropdown(
                        value: org,
                        title: 'สาขา',
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
                        value: position.toString(),
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
              RaisedButton(
                child: Text('asdf'),
                onPressed: _showBranchModal,
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
    value,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                value,
                style: TextStyle(
                  fontFamily: _kanit,
                  fontSize: 18.0,
                ),
              ),
              Icon(
                Icons.arrow_drop_down,
              ),
            ],
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
