import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

final _kanit = 'Kanit';

showAlert(BuildContext context, alerttype, des){
  return Alert(
        context: context,
        type: alerttype,
        title: "",
        desc: des,
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
