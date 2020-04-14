import 'package:flutter/material.dart';
import 'dart:convert';

var place = ['rinma', 'vichaijej', 'barrain'];

void placeJson(String jsonStr) {
  Map<String, dynamic> myMap = json.decode(jsonStr);
}

class Modal {
  mainBottomSheet(BuildContext context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        )),
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _createTile(context, 'Rinma', _rinma),
              _createTile(context, 'Vichaivej', _vichaivej),
              _createTile(context, 'Barrain', _barrain),
            ],
          );
        });
  }
}

ListTile _createTile(BuildContext context, String name, Function action) {
  return ListTile(
    title: Text(name),
    onTap: () {
      Navigator.pop(context);
      action();
    },
  );
}

_rinma() {
  print('rinnma');
}

_vichaivej() {
  print('vichaiveg');
}

_barrain() {
  print('barrain');
}
