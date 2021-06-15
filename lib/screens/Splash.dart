import 'dart:async';
import 'dart:convert';

import 'package:app/apis/login.dart';
import 'package:app/public/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  String phoneNumber = '';
  String uid = '';
  String deviceId = '';
  String token = '';
  SharedPreferences prefs;
  AnimationController animationController;
  Animation<double> animation;
  bool _visible = true;

  startTime() async {
    return new Timer(Duration(seconds: 1), toNextPage);
  }

  void toNextPage() async {
    prefs = await SharedPreferences.getInstance();
    var res = await LoginApi.loignjwt();
    if (res['success']) {
      SharedPreferences sp = await SharedPreferences.getInstance();
      var profile = jsonEncode(res['result']['user']);
      sp.setString('token', res['result']['token']);
      sp.setString('profile', profile);
      Navigator.pushReplacementNamed(context, HOME_SCREEN);
    } else
      Navigator.pushReplacementNamed(context, LOGIN_SCREEN);
  }

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 1));
    animation =
        new CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => this.setState(() {}));
    animationController.forward();

    setState(() {
      _visible = !_visible;
    });
    startTime();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(body: body(context)));
  }

  Widget body(BuildContext context) {
    return Container(
      child: Text("splash"),
    );
    return Container(
        child: Stack(children: <Widget>[Center(child: Text("Splash"))]));
  }
}
