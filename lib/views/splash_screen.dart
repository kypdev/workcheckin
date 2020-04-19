import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workcheckin/views/bt_nav_bar.dart';
import 'package:workcheckin/views/home_screen.dart';
import 'package:workcheckin/views/signin_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SharedPreferences sharedPreferences;
  var loginFlag;

  _getLoginFlag() async{
    sharedPreferences = await SharedPreferences.getInstance();
    //กำหนดค่า LoginFlag
    setState(() {
      loginFlag = sharedPreferences.getInt('loginFlag');
      print(loginFlag);
      if(loginFlag == 1){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: ((context){
              return  HomeScreen();
            }),
          ),
        );
      }else{
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: ((context){
              return  SigninScreen();
            }),
          ),
        );
      }
    });
  }

  @override
  void initState() {
    _getLoginFlag();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Loading...'),
      ),
    );
  }
}
