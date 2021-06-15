import 'package:app/public/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StepIndicator extends StatefulWidget {
  final int steps;
  final List<String> stepTexts;
  final int step;
  StepIndicator({this.steps = 2, this.stepTexts, this.step});
  @override
  StepIndicatorState createState() => StepIndicatorState();
}

class StepIndicatorState extends State<StepIndicator> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var noSpace = EdgeInsets.all(0);
    var round =
        BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(18)));
    List<Widget> widgets = [];
    List<Widget> titles = [];

    widgets.add(Expanded(
      child: Container(
        color: MainTrans,
        height: 8,
      ),
    ));

    for (var i = 0; i < widget.steps; i++) {
      titles.add(Expanded(
          child: Container(
        alignment: Alignment.center,
        child: Text(
          widget.stepTexts[i],
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      )));

      widgets.add(Container(
        alignment: Alignment.center,
        child: Text(
          (i + 1).toString(),
          textAlign: TextAlign.center,
          // style: TextStyle(color: MainWhite),
        ),
        width: 24,
        height: 24,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            color: i == widget.step - 1
                ? MainYellow
                : i < widget.step - 1
                    ? MainBlue
                    : MainGrey),
      ));
      widgets.add(Expanded(
        child: Container(
          color: i == widget.step - 1
              ? MainYellow
              : i < widget.step - 1
                  ? MainBlue
                  : MainGrey,
          height: 8,
        ),
      ));
      widgets.add(Expanded(
        child: Container(
          color: i == widget.step - 1
              ? MainGrey
              : i < widget.step - 1
                  ? MainBlue
                  : MainGrey,
          height: 8,
        ),
      ));
    }
    widgets.removeLast();
    widgets.removeLast();
    widgets.add(Expanded(
      child: Container(
        color: MainTrans,
        height: 8,
      ),
    ));
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: titles,
          ),
          SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: widgets,
          )
        ],
      ),
    );
  }
}
