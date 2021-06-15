import 'package:app/apis/user.dart';
import 'package:app/components/custom-elevated-button.dart';
import 'package:app/components/custom_input.dart';
import 'package:app/components/input-field.dart';
import 'package:app/models/job.dart';
import 'package:app/models/job_categories.dart';
import 'package:app/models/user.dart';
import 'package:app/public/colors.dart';
import 'package:app/public/strings.dart' as Strings;
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
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/screens/contract/messagebox.dart';
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
  TextEditingController phoneController = new TextEditingController();
  TextEditingController budgetController = new TextEditingController();
  TextEditingController deadlineController = new TextEditingController();
  TextEditingController messageController = new TextEditingController();
  getJob() async {
    setState(() {
      isLoading = true;
    });
    var res = await UserApi.getJobDetail(widget.jobId);
    if (res['success']) {
      job.fromJson(res['result']['job']);
      client.fromJson(res['result']['job']['client_id']);
      applied = res['result']['applied'];
      for (var json in res['result']['jobTypes']) {
        var cat = JobCategory();
        cat.fromJson(json);
        jobTypes.add(cat);
      }
      contracts = res['result']['contracts'];
    }
    setState(() {
      isLoading = false;
    });
  }

  doAction() {
    var deadline;
    if (applied)
      Navigator.push(
          context,
          new CupertinoPageRoute(
              builder: (context) => ContractScreen(jobId: widget.jobId)));
    else
      showModalBottomSheet(
          isScrollControlled: true,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.0))),
          // expand: false,
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 24),
              height: 540,
              // decoration: BoxDecoration(
              //     borderRadius:
              //         BorderRadius.vertical(top: Radius.circular(16))),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 32),
                    Text(
                      Strings.phoneNumber,
                      style: TextStyle(color: MainBlack),
                    ),
                    SizedBox(height: 8),
                    CustomInputField(
                      borderColor: WeakGrey,
                      placeHolder: Strings.phoneNumber,
                      controller: phoneController,
                      textInputType: TextInputType.phone,
                    ),
                    SizedBox(height: 12),
                    Text(
                      Strings.contractAmount,
                      style: TextStyle(color: MainBlack),
                    ),
                    SizedBox(height: 8),
                    CustomInputField(
                        borderColor: WeakGrey,
                        placeHolder: Strings.contractAmount,
                        textInputType: TextInputType.number,
                        controller: budgetController,
                        suffixIcon: Container(
                            width: 12,
                            alignment: Alignment.centerRight,
                            margin: EdgeInsets.only(right: 18),
                            child: Text(
                              '円',
                              style: TextStyle(color: MainBlue),
                            ))),
                    SizedBox(height: 12),
                    Text(
                      Strings.estDeadline,
                      style: TextStyle(color: MainBlack),
                    ),
                    SizedBox(height: 8),
                    CustomInputField(
                        borderColor: WeakGrey,
                        placeHolder: Strings.estDeadline,
                        controller: deadlineController,
                        readOnly: true,
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.insert_invitation,
                            color: MainBlue,
                          ),
                          splashRadius: 20,
                          color: MainBlue,
                          onPressed: () async {
                            deadline = await showRoundedDatePicker(
                                context: context, initialDate: DateTime.now());
                            if (deadline == null) return;
                            deadlineController.text =
                                Utils.formatDate(deadline);
                            setState(() {});
                          },
                        )),
                    SizedBox(height: 12),
                    Text(
                      Strings.applyMessage,
                      style: TextStyle(color: MainBlack),
                    ),
                    SizedBox(height: 8),
                    CustomInputField(
                      borderColor: WeakGrey,
                      placeHolder: Strings.applyMessage,
                      lines: 10,
                      height: 160.0,
                      alignment: Alignment.topLeft,
                      controller: messageController,
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        customElevatedButton(
                          text: Strings.applytoThis,
                          backColor: MainRed,
                          onPressed: () async {
                            var r = await messageBox(context,
                                content: Strings.declineClientOffer);
                            if (!r) return;

                            var res = await UserApi.applyJob(
                                job.id,
                                phoneController.text,
                                budgetController.text,
                                messageController.text,
                                deadline.toString());
                            if (res['success']) {
                              setState(() => applied = true);
                              Navigator.of(context).pop();
                            }
                          },
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          });
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
              floatingActionButton: customElevatedButton(
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
