import 'dart:convert';

import 'package:app/apis/user.dart';
import 'package:app/components/iconbutton.dart';
import 'package:app/models/job.dart';
import 'package:app/models/job_categories.dart';
import 'package:app/models/user.dart';
import 'package:app/public/colors.dart';
import 'package:app/public/constants.dart';
import 'package:app/public/strings.dart' as Strings;
import 'package:app/screens/home/category-title.dart';
import 'package:app/screens/job/job.dart';
import 'package:app/widgets/job_card.dart';
import 'package:app/widgets/nav_drawer.dart';
import 'package:app/widgets/search_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  bool isLoading = true;
  List<JobCategory> categories = [];
  List<Job> jobs = [];
  bool dropdownOn = false;
  int category = 0;
  String keyword = '';
  User profile = new User();
  DateTime to = DateTime.now();
  DateTime from = DateTime.now().subtract(Duration(days: 7));
  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance()
        .then((sp) => profile.fromJson(jsonDecode(sp.getString('profile'))));
    getCategories();
  }

  getCategories() async {
    setState(() {
      isLoading = true;
    });
    var result = await UserApi.getCategories();
    if (result['success']) {
      var jsons = result['result'];
      for (var json in jsons) {
        var category = new JobCategory();
        category.fromJson(json);
        categories.add(category);
      }

      await update();
    } else {}
  }

  // getJobsofPast7({keyword = '', category = 0}) async {
  //   searchJobs(
  //       keyword: keyword,
  //       category: category,
  //       from: DateTime.now().subtract(Duration(days: 7)),
  //       to: DateTime.now());
  // }

  searchJobs({keyword = '', category = 0, from, to}) async {
    setState(() => isLoading = true);
    var res = await UserApi.getJobsofDays(from, to,
        keyword: keyword, category: category);
    if (res['success']) {
      jobs = [];
      for (var json in res['result']) {
        var job = new Job();
        job.fromJson(json);
        jobs.add(job);
      }
    }
    setState(() => isLoading = false);
  }

  openSearch() async {
    var conditions = await showMaterialModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0))),
        context: context,
        builder: (context) => SearchSheet(categories: categories));
    if (conditions == null) return;
    keyword = conditions['keyword'];
    category = conditions['category'];
    from = conditions['from'];
    to = conditions['to'];
    setState(() {});
    await update();
  }

  update() async {
    await searchJobs(keyword: keyword, category: category, from: from, to: to);
  }

  selectCategory(int type) async {
    setState(() => category = type);
    await update();
  }

  toJobPage(job) {
    Navigator.of(context).push(
        new CupertinoPageRoute(builder: (context) => JobScreen(jobId: job.id)));
  }

  doLogout() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('token', '');
    Phoenix.rebirth(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: LoadingOverlay(
            opacity: 0.5,
            isLoading: isLoading,
            progressIndicator: CircularProgressIndicator(),
            child: Scaffold(
              appBar: AppBar(
                title: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('$IMG_PATH/logo.png', height: 64, width: 64),
                      Text(
                        'アプリ名',
                        style: TextStyle(color: MainBlack),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                  margin: EdgeInsets.only(right: 54),
                ),
                iconTheme: IconThemeData(color: MainBlack),
                backgroundColor: MainWhite,
                elevation: 0,
                centerTitle: true,
              ),
              body: homeScreen(),
              floatingActionButton: Container(
                child: FloatingActionButton(
                  backgroundColor: MainBlue,
                  child: Icon(Icons.search, size: 20),
                  onPressed: openSearch,
                ),
                width: 40,
              ),
              drawer: NavDrawer(logout: doLogout, profile: profile),
            )));
  }

  Widget jobPanel() {
    List<Widget> widgets = [];
    for (Job job in jobs) {
      widgets.add(jobCard(job, () => toJobPage(job)));
    }
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 0.64,
      children: widgets,
    );
  }

  Widget homeScreen() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6),
      color: MainWhite,
      child: Column(
        children: [
          categoryTitle(categories, category, selectCategory),
          Expanded(child: jobPanel())
        ],
      ),
    );
  }
}
