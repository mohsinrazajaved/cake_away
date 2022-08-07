import 'package:cake_away/Auth/login.dart';
import 'package:cake_away/Home/home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  const Splash({Key key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  _checkStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = prefs?.getBool('isLoggedIn') ?? false;
    if (status) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return Home();
      }));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return Login();
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Image.asset("assets/sfinal.png");
  }
}
