import 'dart:convert';

import 'package:app/apis/user.dart';
import 'package:app/components/custom-elevated-button.dart';
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
import 'package:pull_to_refresh/pull_to_refresh.dart';
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
  int filter = 0;
  int curPageIndex = 0;
  int _pageSize = 60;
  List<String> filters = [
    Strings.all,
    Strings.applied,
    Strings.progressing,
    Strings.finished,
    Strings.favorite
  ];

  bool isLastPage = false;
  String keyword = '';
  User profile = new User();
  DateTime to = DateTime.now();
  DateTime from = DateTime.now().subtract(Duration(days: 7));
  bool pastweek = true;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance()
        .then((sp) => profile.fromJson(jsonDecode(sp.getString('profile'))));
    getCategories();
    // _refreshIndicatorKey.currentState.show();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _fetchPage(int pageIndex) async {
    try {
      setState(() => isLoading = true);
      final res = await UserApi.getJobsofDays(from, to,
          keyword: keyword,
          category: category,
          filter: filter,
          pageIndex: pageIndex,
          pageSize: _pageSize);
      var newItems = res['result'];
      if (pageIndex == 0)
        jobs = Job.fromJsonList(newItems);
      else
        jobs.addAll(Job.fromJsonList(newItems));
      isLastPage = newItems.length < _pageSize;

      isLoading = false;
      setState(() {});
    } catch (error) {}
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

  onLoading() async {
    if (isLastPage) {
      _refreshController.loadNoData();
      return;
    }
    await _fetchPage(++curPageIndex);
    _refreshController.loadComplete();
  }

  Future<void> loadMore() async {
    _refreshController.refreshCompleted();
  }
  // getJobsofPast7({keyword = '', category = 0}) async {
  //   searchJobs(
  //       keyword: keyword,
  //       category: category,
  //       from: DateTime.now().subtract(Duration(days: 7)),
  //       to: DateTime.now());
  // }

  // searchJobs({keyword = '', category = 0, filter = 0, from, to}) async {
  //   setState(() => isLoading = true);
  //   var res = await UserApi.getJobsofDays(from, to,
  //       keyword: keyword,
  //       category: category,
  //       filter: filter,
  //       pageKey: 0,
  //       pageSize: _pageSize);
  //   if (res['success']) {
  //     jobs = [];
  //     jobs = Job.fromJsonList(res['result']);
  //   }
  //   setState(() => isLoading = false);
  // }

  openSearch() async {
    var conditions = await showMaterialModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0))),
        context: context,
        builder: (context) => SearchSheet(
              categories: categories,
              from: from,
              to: to,
              keyword: keyword,
              category: category,
              pastweek: pastweek,
            ));
    if (conditions == null) return;
    keyword = conditions['keyword'];
    category = conditions['category'];
    from = conditions['from'];
    to = conditions['to'];
    pastweek = conditions['pastWeek'];
    setState(() {});
    await update();
  }

  update() async {
    curPageIndex = 0;
    isLastPage = false;
    _refreshController.loadComplete();
    await _fetchPage(0);
  }

  selectFilter(int filter) async {
    setState(() => this.filter = filter);
    await update();
  }

  toJobPage(job) {
    Navigator.of(context).push(
        new CupertinoPageRoute(builder: (context) => JobScreen(jobId: job.id)));
  }

  toggleFavorite(jobId) async {
    setState(() => isLoading = true);

    var res = await UserApi.toggleFavorite(jobId);

    if (res['success']) {
      setState(() => (jobs.singleWhere((element) => element.id == jobId))
          .favorite = res['result']);
      if (!res['result'] && filter == 4)
        jobs.removeWhere((element) => element.id == jobId);
    }

    setState(() => isLoading = false);
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
      widgets.add(
          jobCard(job, () => toJobPage(job), () => toggleFavorite(job.id)));
    }
    // return PagewiseGridView<Job>.count(
    //   pageSize: _pageSize,
    //   crossAxisCount: 2,
    //   childAspectRatio: 0.64,
    //   itemBuilder: ,
    //   pageFuture: (pageIndex) => _fetchPage(pageIndex),
    //     // pagingController: _pagingController,
    //     // builderDelegate: PagedChildBuilderDelegate(
    //     //     itemBuilder: (context, item, index) => jobCard(
    //     //         item, () => toJobPage(item), () => toggleFavorite(item.id))));
    return SmartRefresher(
        enablePullUp: true,
        enablePullDown: false,
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              childAspectRatio: 0.64, maxCrossAxisExtent: 200),
          itemCount: jobs.length,
          itemBuilder: (context, index) => jobCard(
              jobs[index],
              () => toJobPage(jobs[index]),
              () => toggleFavorite(jobs[index].id)),
        ),
        controller: _refreshController,
        footer: CustomFooter(
          height: 1,
          builder: (BuildContext context, LoadStatus mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = Container();
            } else if (mode == LoadStatus.loading) {
              body = CupertinoActivityIndicator();
            } else if (mode == LoadStatus.failed) {
              body = Container();
            } else if (mode == LoadStatus.canLoading) {
              body = Container();
            } else {
              body = Container();
            }
            return Container(
              alignment: Alignment.bottomCenter,
              height: 30.0,
              width: 30,
              child: Center(child: body),
            );
          },
        ),
        onLoading: onLoading,
        onRefresh: loadMore);
  }

  Widget homeScreen() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6),
      color: MainWhite,
      child: Column(
        children: [
          filterOption(filters, filter, selectFilter),
          // categoryTitle(categories, category, selectCategory),
          Expanded(child: jobPanel()),
        ],
      ),
    )
        // !isLastPage
        //     ? Align(
        //         alignment: Alignment.bottomCenter,
        //         child:
        //             customElevatedButton(text: 'Load more', onPressed: loadMore))
        //     : Container()
        ;
  }
}
