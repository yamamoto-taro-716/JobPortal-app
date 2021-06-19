import 'package:app/apis/user.dart';
import 'package:app/components/custom-elevated-button.dart';
import 'package:app/components/custom_input.dart';
import 'package:app/components/input-field.dart';
import 'package:app/models/job.dart';
import 'package:app/models/job_categories.dart';
import 'package:app/models/user.dart';
import 'package:app/public/colors.dart';
import 'package:app/public/strings.dart' as Strings;
import 'package:app/screens/job/applysheet.dart';
import 'package:app/utils/utils.dart' as Utils;
import 'package:app/screens/contract/contract.dart';
import 'package:app/widgets/job_card.dart';
import 'package:app/screens/job/client.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:http/http.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/screens/job/contracts.dart';

class JobScreen extends StatefulWidget {
  final String jobId;
  JobScreen({@required this.jobId});
  JobScreenState createState() => JobScreenState();
}

class JobScreenState extends State<JobScreen> {
  bool isLoading = false;
  var job = new Job();
  var client = new User();
  var applied = false;

  List<JobCategory> jobTypes = [];
  List<dynamic> contracts = [];

  getJob() async {
    setState(() {
      isLoading = true;
    });
    var res = await UserApi.getJobDetail(widget.jobId);
    if (res['success']) {
      job = Job.fromJson(res['result']['job']);
      client.fromJson(res['result']['job']['client_id']);
      applied = res['result']['applied'];
      for (var json in res['result']['jobTypes']) {
        var cat = JobCategory();
        cat.fromJson(json);
        jobTypes.add(cat);
      }
      contracts = res['result']['contracts'];
    }
    // await Future.delayed(Duration(seconds: 3));
    setState(() {
      isLoading = false;
    });
  }

  doAction() async {
    bool cancelled = false;
    if (applied)
      cancelled = await Navigator.push(
          context,
          new CupertinoPageRoute(
              builder: (context) => ContractScreen(jobId: widget.jobId)));
    else {
      var applied = await showModalBottomSheet(
          isScrollControlled: true,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.0))),
          // expand: false,
          context: context,
          builder: (context) => ApplySheet(jobId: job.id));
      if (applied == null) applied = false;
      this.applied = applied;
      setState(() {});
      if (this.applied)
        cancelled = await Navigator.push(
            context,
            new CupertinoPageRoute(
                builder: (context) => ContractScreen(jobId: widget.jobId)));
    }
    if (cancelled) setState(() => applied = false);
  }

  @override
  void initState() {
    super.initState();
    getJob();
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
                title: Text(
                  Strings.jobDetail,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: MainBlack),
                ),
                centerTitle: true,
                leading: BackButton(
                  onPressed: () => Navigator.pop(context),
                  color: MainBlue,
                ),
                elevation: 0.0,
                backgroundColor: MainWhite,
              ),
              body: jobScreen(),
              floatingActionButton: isLoading
                  ? Container()
                  : customElevatedButton(
                      text: applied ? Strings.toContract : Strings.applytoThis,
                      backColor: MainRed,
                      onPressed: doAction),
            )));
  }

  Widget jobScreen() {
    if (isLoading) return Container();

    var deadline = job.deadLine == null
        ? Strings.noDeadline
        : Utils.formatDate(job.deadLine);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24),
      width: double.infinity,
      height: double.infinity,
      color: MainWhite,
      child: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 24),
          Container(
              padding: EdgeInsets.only(left: 12, bottom: 4),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  border: Border(left: BorderSide(color: MainRed, width: 4))),
              child: Text(
                job.title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              )),
          SizedBox(height: 20),
          ClientWidget(job: job),
          SizedBox(height: 20),
          Row(children: [
            Icon(Icons.attach_money, color: SecondGrey),
            Text(Strings.budget, style: TextStyle(fontWeight: FontWeight.bold))
          ]),
          SizedBox(height: 4),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  color: MainRed),
              child: Text(Strings.budgetRange[job.budgetRange],
                  style: TextStyle(color: MainWhite))),
          SizedBox(height: 16),
          Row(children: [
            Icon(Icons.insert_invitation, color: SecondGrey),
            Text(Strings.deadline,
                style: TextStyle(fontWeight: FontWeight.bold))
          ]),
          SizedBox(height: 4),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  color: MainRed),
              child: Text('$deadline', style: TextStyle(color: MainWhite))),
          SizedBox(height: 16),
          Text(Strings.dateApplied,
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text(Utils.formatDate(job.date)),
          SizedBox(height: 16),
          Container(
              margin: EdgeInsets.only(bottom: 6),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  color: SecondGrey),
              child: Text(Strings.jobDescription,
                  style: TextStyle(color: MainWhite))),
          Container(child: Text(job.description, style: TextStyle())),
          SizedBox(height: 20),
          Contracts(contracts: contracts),
          SizedBox(height: 48),
        ],
      )),
    );
  }
}
