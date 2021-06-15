import 'dart:async';

import 'package:app/apis/login.dart';
import 'package:app/public/colors.dart';
import 'package:app/public/constants.dart';
import 'package:app/public/strings.dart' as Strings;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  ProfileScreenState createState() => new ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(body: body(context)));
  }

  Widget body(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.profile),
        leading: BackButton(
          color: MainWhite,
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }
}
