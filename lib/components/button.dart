import 'package:app/public/colors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final double height;
  final double fontSize;
  final Function onPressed;
  final Color color;
  final Color textColor;
  final bool border;

  const CustomButton(
      {Key key,
      @required this.text,
      this.height = 36.0,
      this.fontSize = 16.0,
      this.onPressed,
      this.border = true,
      this.color = MainWhite,
      this.textColor = MainBlue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      customBorder: new RoundedRectangleBorder(
          side: border ? BorderSide(color: MainBlue) : BorderSide.none,
          borderRadius: new BorderRadius.circular(30.0)),
      child: Container(
          // width: width,
          height: height,
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              border: border ? Border.all(color: MainBlue) : Border()
              // gradient: LinearGradient(
              //   begin: Alignment.centerLeft,
              //   end: Alignment.centerRight,
              //   colors: <Color>[
              //     color == null ? MainGreen : color,
              //     color == null ? MainGreen : color
              //   ],
              // ),
              ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                  fontFamily: "OpenSans",
                  fontStyle: FontStyle.normal,
                  fontSize: fontSize),
            ),
          )),
    );
  }
}
