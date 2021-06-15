import 'package:app/apis/user.dart';
import 'package:app/components/button.dart';
import 'package:app/components/custom-elevated-button.dart';
import 'package:app/components/custom_input.dart';
import 'package:app/components/input-field.dart';
import 'package:app/public/colors.dart';
import 'package:app/public/constants.dart';
import 'package:app/public/strings.dart' as Strings;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController pwdController = new TextEditingController();

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
        child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: MainGrey,
              leading: BackButton(
                onPressed: () => Navigator.of(context).pop(),
                color: MainBlue,
              ),
            ),
            backgroundColor: MainGrey,
            body: loginScreen()));
  }

  Widget loginScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
              color: MainWhite,
              // border: Border.all(color: MainRed),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
          child: Column(
            children: [
              SizedBox(height: 60),
              CustomInputField(
                placeHolder: Strings.email,
                controller: emailController,
                borderColor: MainBlue,
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
                borderColor: MainBlue,
                prefixIcon: Icon(
                  Icons.lock,
                  color: MainBlue,
                ),
              ),
              SizedBox(height: 40),
              // CustomButton(text: login, onPressed: doLogin),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  customElevatedButton(
                      backColor: MainBlue,
                      height: 32.0,
                      fontSize: 14.0,
                      text: Strings.login,
                      onPressed: doLogin),
                  customElevatedButton(
                      backColor: MainGrey,
                      height: 32.0,
                      fontSize: 14.0,
                      text: Strings.register,
                      onPressed: doLogin),
                ],
              ),
              SizedBox(height: 60),
            ],
          ),
        )
      ],
    );
  }

  doLogin() async {
    var res = await UserApi.login(emailController.text, pwdController.text);
    if (res['success']) {
      SharedPreferences sp = await SharedPreferences.getInstance();
      sp.setString('token', res['result']['token']);
      Navigator.pushReplacementNamed(context, HOME_SCREEN);
    }
  }
}
