import 'dart:convert';

import 'package:app/apis/user.dart';
import 'package:app/components/button.dart';
import 'package:app/components/custom-elevated-button.dart';
import 'package:app/components/custom_input.dart';
import 'package:app/components/iconbutton.dart';
import 'package:app/components/input-field.dart';
import 'package:app/public/colors.dart';
import 'package:app/public/constants.dart';
import 'package:app/public/strings.dart' as Strings;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController pwdController = new TextEditingController();
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    pwdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: MainGrey,
        body: loginScreen(),
      ),
    ));
  }

  Widget loginScreen() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.only(top: 120),
          alignment: Alignment.topCenter,
          child: Image.asset('$IMG_PATH/logo.png', width: 180, height: 180),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [MainBlue, MainGreen])),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Container(
            //     child: Image.asset('$IMG_PATH/logo.png', width: 180, height: 180)),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                  color: MainWhite,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(16))),
              child: Column(
                children: [
                  SizedBox(height: 48),
                  CustomInputField(
                    placeHolder: Strings.email,
                    controller: emailController,
                    borderColor: WeakGrey,
                    textInputType: TextInputType.emailAddress,
                    prefixIcon: Icon(
                      Icons.email,
                      color: MainBlue,
                    ),
                  ),
                  SizedBox(height: 20),
                  CustomInputField(
                    placeHolder: Strings.password,
                    controller: pwdController,
                    obscureText: true,
                    borderColor: WeakGrey,
                    prefixIcon: Icon(
                      Icons.lock,
                      color: MainBlue,
                    ),
                  ),
                  SizedBox(height: 20),
                  customElevatedButton(
                      width: double.infinity,
                      backColor: MainBlue,
                      height: 40.0,
                      fontSize: 14.0,
                      text: Strings.login,
                      margin: 0.0,
                      onPressed: doLogin),
                  SizedBox(height: 20),
                  customElevatedButton(
                      backColor: MainWhite,
                      textColor: MainRed,
                      height: 32.0,
                      fontSize: 14.0,
                      text: Strings.forgotPassword,
                      margin: 0.0,
                      onPressed: () {}),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(Strings.dontHaveAccount),
                      customElevatedButton(
                          backColor: MainWhite,
                          textColor: DarkGrey,
                          height: 32.0,
                          fontSize: 14.0,
                          text: Strings.register,
                          margin: 0.0,
                          onPressed: () {}),
                    ],
                  ),
                  SizedBox(height: 40),
                ],
              ),
            )
          ],
        )
      ],
    );
  }

  doLogin() async {
    setState(() => isLoading = true);
    var res = await UserApi.login(emailController.text, pwdController.text);
    if (res['success']) {
      SharedPreferences sp = await SharedPreferences.getInstance();
      sp.setString('token', res['result']['token']);
      var profile = jsonEncode(res['result']['user']);
      sp.setString('profile', profile);
      setState(() => isLoading = false);
      Navigator.pushReplacementNamed(context, HOME_SCREEN);
    }
    setState(() => isLoading = false);
  }
}
