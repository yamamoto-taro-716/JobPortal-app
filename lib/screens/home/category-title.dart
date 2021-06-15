import 'package:app/components/custom-elevated-button.dart';
import 'package:app/models/job_categories.dart';
import 'package:app/public/colors.dart';
import 'package:app/public/strings.dart' as Strings;
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

Widget categoryTitle(List<JobCategory> categories, int curCategory, onPressed) {
  List<Widget> widgets = [];
  widgets.add(customElevatedButton(
      backColor: curCategory == 0 ? MainRed : WeekGrey,
      textColor: curCategory == 0 ? MainWhite : MainBlack,
      text: Strings.all,
      fontSize: 12.0,
      height: 28.0,
      onPressed: () => onPressed(0)));
  for (var category in categories) {
    widgets.add(customElevatedButton(
        backColor: curCategory == category.type ? MainRed : WeekGrey,
        textColor: curCategory == category.type ? MainWhite : MainBlack,
        text: category.name,
        fontSize: 12.0,
        height: 28.0,
        onPressed: () => onPressed(category.type)));
  }
  return Container(
    color: MainTrans,
    height: 50,
    margin: EdgeInsets.symmetric(horizontal: 8),
    width: double.infinity,
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: widgets,
      ),
    ),
  );
}
