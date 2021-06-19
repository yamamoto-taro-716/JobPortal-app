import 'package:app/components/button.dart';
import 'package:app/components/custom-elevated-button.dart';
import 'package:app/components/custom_input.dart';
import 'package:app/components/input-field.dart';
import 'package:app/models/job_categories.dart';
import 'package:app/public/colors.dart';
import 'package:app/public/strings.dart' as Strings;
import 'package:app/utils/utils.dart' as Utils;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';

class SearchSheet extends StatefulWidget {
  final List<JobCategory> categories;
  final DateTime from;
  final DateTime to;
  final String keyword;
  final int category;
  final bool pastweek;
  SearchSheet(
      {this.categories,
      this.from,
      this.to,
      this.keyword = "",
      this.category,
      this.pastweek = true});
  @override
  State<StatefulWidget> createState() {
    return SearchSheetState();
  }
}

class SearchSheetState extends State<SearchSheet> {
  TextEditingController keywordText = new TextEditingController();
  int curCategory = 0;
  DateTime dateFrom, dateTo;
  bool collapsed = true;
  String durationText = Strings.pastWeek;
  bool bPastWeek = true;
  ddSelected() {}
  selectDate(from) async {
    DateTime date = await showRoundedDatePicker(
        context: context, initialDate: from ? dateFrom : dateTo);
    if (date == null) return;
    if (from) {
      if (dateFrom != date) {
        dateFrom = date;
        setDuration();
      }
    } else if (dateFrom != date) {
      dateTo = date;
      setDuration();
    }
    setState(() {});
  }

  setDuration() {
    durationText =
        Utils.formatDate(dateFrom) + ' ~ ' + Utils.formatDate(dateTo);
    bPastWeek = false;
  }

  setPastWeek() {
    dateTo = DateTime.now();
    dateFrom = dateTo.subtract(Duration(days: 7));
    durationText = Strings.pastWeek;
    bPastWeek = true;
    setState(() {});
  }

  returnSearch() {
    Map<String, dynamic> searchConditions = {};
    searchConditions['keyword'] = keywordText.text;
    searchConditions['from'] = dateFrom;
    searchConditions['to'] = dateTo;
    searchConditions['category'] = curCategory;
    searchConditions['pastWeek'] = bPastWeek;
    Navigator.of(context).pop(searchConditions);
  }

  @override
  void initState() {
    super.initState();
    keywordText.text = widget.keyword;
    curCategory = widget.category;
    this.dateFrom = widget.from;
    this.dateTo = widget.to;
    // this.keywordText = widget.keyword;
    this.curCategory = widget.category;
    this.bPastWeek = widget.pastweek;
    if (!bPastWeek) setDuration();
    // setPastWeek();
  }

  @override
  void dispose() {
    keywordText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem> ddItems = [];
    ddItems.add(DropdownMenuItem(
      value: 0,
      child: Text(
        Strings.all,
        style: TextStyle(fontSize: 14),
      ),
      onTap: () {
        ddSelected();
      },
    ));
    for (JobCategory cat in widget.categories) {
      ddItems.add(DropdownMenuItem(
        value: cat.type,
        child: Text(
          cat.name,
          style: TextStyle(fontSize: 14),
        ),
        onTap: () {
          ddSelected();
        },
      ));
    }
    return Container(
      height: 512,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
          color: MainWhite),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              Strings.searchAll,
              style: TextStyle(
                  fontSize: 20, color: MainBlack, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            CustomInputField(
              placeHolder: Strings.keyword,
              controller: keywordText,
              borderColor: MainGrey,
              backColor: MainWhite,
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(Strings.jobCategory),
                    Container(
                      width: 200,
                      height: 40,
                      padding: EdgeInsets.only(left: 12, right: 12),
                      decoration: BoxDecoration(
                          color: MainWhite,
                          border: Border.all(color: MainGrey),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          items: ddItems,
                          value: curCategory,
                          onChanged: (value) {
                            setState(() {
                              curCategory = value;
                            });
                          },
                          isExpanded: true,
                        ),
                      ),
                    )
                  ]),
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                  border: Border.all(color: MainGrey)),
              child: GFAccordion(
                  titlePadding: EdgeInsets.symmetric(horizontal: 12),
                  showAccordion: !collapsed,
                  onToggleCollapsed: (collapsed) =>
                      setState(() => this.collapsed = !collapsed),
                  margin: EdgeInsets.all(0),
                  titleBorderRadius: collapsed
                      ? BorderRadius.all(Radius.circular(24))
                      : BorderRadius.vertical(top: Radius.circular(24)),
                  contentBorderRadius: !collapsed
                      ? BorderRadius.all(Radius.circular(24))
                      : BorderRadius.vertical(bottom: Radius.circular(24)),
                  titleChild: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text(Strings.postDate), Text(durationText)],
                    ),
                    height: 40,
                  ),
                  expandedTitleBackgroundColor: MainWhite,
                  contentChild: Container(
                    child: Column(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              customElevatedButton(
                                text: Strings.pastWeek,
                                onPressed: setPastWeek,
                                height: 30.0,
                              ),
                            ]),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  customElevatedButton(
                                    text: Utils.formatDate(dateFrom),
                                    backColor: MainWhite,
                                    textColor: MainBlue,
                                    height: 30.0,
                                    onPressed: () => selectDate(true),
                                  ),
                                  SizedBox(width: 20),
                                  Text(Strings.from)
                                ],
                              ),
                            ),
                            Container(
                              child: Row(
                                children: [
                                  customElevatedButton(
                                    text: Utils.formatDate(dateTo),
                                    backColor: MainWhite,
                                    textColor: MainBlue,
                                    height: 30.0,
                                    onPressed: () => selectDate(false),
                                  ),
                                  SizedBox(width: 20),
                                  Text(Strings.to)
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  )),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                customElevatedButton(
                    backColor: MainRed,
                    text: Strings.search,
                    onPressed: returnSearch,
                    height: 30.0),
                SizedBox(width: 0),
                customElevatedButton(
                    text: Strings.cancel,
                    backColor: MainGrey,
                    height: 30.0,
                    onPressed: () => Navigator.of(context).pop(null))
              ],
            )
          ],
        ),
      ),
    );
  }
}
