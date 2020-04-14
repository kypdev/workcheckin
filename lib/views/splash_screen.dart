import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workcheckin/views/signin_screen.dart';

import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SharedPreferences sharedPreferences;
  int loginFlag;

  _setLoginFlag() async{
    sharedPreferences = await SharedPreferences.getInstance();
    //กำหนดค่า LoginFlag
    setState(() {
      sharedPreferences.setInt("LoginFlag", 2);
    });
  }

  _getLoginFlag() async{
    sharedPreferences = await SharedPreferences.getInstance();
    //กำหนดค่า LoginFlag
    setState(() {
      loginFlag = sharedPreferences.getInt("LoginFlag");
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
    _setLoginFlag();
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
