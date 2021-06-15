import 'package:app/public/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget customElevatedButton(
    {text,
    onPressed,
    textColor = MainWhite,
    backColor = MainBlue,
    fontSize = 13.0,
    width,
    margin = 4.0,
    height = 36.0}) {
  if (width == null)
    return Container(
      height: height,
      margin: EdgeInsets.symmetric(horizontal: margin),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: backColor,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20))),
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: fontSize),
          )),
    );
  else
    return Container(
      height: height,
      width: width,
      margin: EdgeInsets.symmetric(horizontal: margin),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: backColor,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20))),
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: fontSize),
          )),
    );
}
