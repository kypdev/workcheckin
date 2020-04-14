import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'modal.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:intl/intl.dart';
import 'package:device_info/device_info.dart';

final oCcy = new NumberFormat("#,##0.00", "en_US");

class EmployeeScreen extends StatefulWidget {
  @override
  _EmployeeScreenState createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  double distance;
  String latitude = '';
  String longtitude = '';
  String place = '';

  Modal modal = Modal();

  modalPlace() {
    print('place');
  }

  void _calDistance() async {
    double distanceInMeters = await Geolocator().distanceBetween(13.7073418,
        100.3539335, double.parse(latitude), double.parse(longtitude));

    print(distanceInMeters);
    Alert(
      context: context,
      type: AlertType.success,
      title: "Distance",
      desc: '${oCcy.format(distanceInMeters)} Meters',
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
        )
      ],
    ).show();
  }

  selectPlace() {
    print('select place');
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

  ListTile _createTile(BuildContext context, String name, Function action) {
    return ListTile(
      title: Text(name),
      onTap: () {
        Navigator.pop(context);
        action();
      },
    );
  }

  alert({distanses}) {
    Alert(
      context: context,
      type: AlertType.success,
      title: "Distance",
      desc: '$distanses',
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
        )
      ],
    ).show();
  }

  _rinma() {
    print('rinnma');
    setState(() {
      place = 'RINMA';
      latitude = '13.705741';
      longtitude = '100.3403874';
    });
  }

  _vichaivej() {
    print('vichaiveg');
    setState(() {
      place = 'VICHAIVEJ';
      latitude = '13.7074712';
      longtitude = '100.3584725';
    });
  }

  _barrain() {
    print('barrain');
    setState(() {
      place = 'BARRAIN';
      latitude = '13.7076624';
      longtitude = '100.3622219';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Today',
                textAlign: TextAlign.center,
              ),
              IconButton(
                icon: Icon(
                  Icons.location_on,
                  color: Colors.white,
                ),
                onPressed: selectPlace,
              ),
            ],
          ),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(),
            
Padding(
  padding: const EdgeInsets.only(top: 20, bottom: 50),
  child: Container(
    child: Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector( 
              onTap: _calDistance,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green,
                ),
                child: Icon(
                  FontAwesomeIcons.arrowAltCircleDown,
                  size: 80,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(width: 20),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
              ),
              child: Icon(
                FontAwesomeIcons.arrowAltCircleDown,
                size: 80,
                color: Colors.white,
              ),
            ),
          ],
        ),
        SizedBox(height: 30),
        Text(place),
        SizedBox(height: 10),
        Text('$latitude / $longtitude'),
      ],
    ),
  ),
),

          ],
        ));
  }
}

class deviceInfo extends StatefulWidget {
  @override
  _deviceInfoState createState() => _deviceInfoState();
}

class _deviceInfoState extends State<deviceInfo> {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    Map<String, dynamic> deviceData;

    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
    });
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'id': build.id,
      'model': build.model,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: ListView(
        children: _deviceData.keys.map(
          (String property) {
            return Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        property,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                        child: Container(
                      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                      child: Text(
                        '${_deviceData[property]}',
                        maxLines: 10,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )),
                  ],
                ),
              ],
            );
          },
        ).toList(),
      ),
    );
  }
}
