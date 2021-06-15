import 'package:app/public/colors.dart';
import 'package:app/public/strings.dart' as Strings;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

messageBox(context, {icon = Icons.warning, title = '通知', content}) async {
  var r = await showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CupertinoAlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: DarkYellow),
                SizedBox(width: 12),
                Text(title)
              ],
            ),
            content: Text(content, style: TextStyle(fontSize: 14)),
            actions: <Widget>[
              CupertinoDialogAction(
                  child: Text(Strings.yes, style: TextStyle(fontSize: 14)),
                  onPressed: () => Navigator.of(context).pop(true)),
              CupertinoDialogAction(
                  child: Text(Strings.no, style: TextStyle(fontSize: 14)),
                  onPressed: () => Navigator.of(context).pop(false)),
            ],
          ));
  if (r == null) return false;
  return r;
}
