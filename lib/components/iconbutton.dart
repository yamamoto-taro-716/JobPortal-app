import 'package:app/public/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget iconButton(IconData icon,
    {Color color, width = 32.0, height = 32.0, backColor, onTap}) {
  return InkWell(
      borderRadius: BorderRadius.all(Radius.circular(18)),
      child: Container(
        width: width + 4.0,
        height: height + 4.0,
        child: Icon(
          icon,
          size: width,
          color: color == null ? MainGreen : color,
        ),
        decoration:
            BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(40))),
      ),
      onTap: onTap);
}

Widget customInkwell({onTap, Widget child, radius = 30.0}) {
  return InkWell(
      customBorder: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(radius)),
      onTap: onTap,
      child: child);
}

Widget linkLabel(
    {onTap,
    fontSize = 14.0,
    text,
    fontColor = MainGrey,
    fontWeight = FontWeight.normal}) {
  return customInkwell(
      onTap: onTap,
      child: Container(
          child: Text(text,
              style: TextStyle(
                  color: fontColor, fontSize: fontSize, fontWeight: fontWeight),
              overflow: TextOverflow.fade),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4)));
}
