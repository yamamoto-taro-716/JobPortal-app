import 'package:app/apis/user.dart';
import 'package:app/components/custom-elevated-button.dart';
import 'package:app/models/contract.dart';
import 'package:app/models/job.dart';
import 'package:app/models/job_categories.dart';
import 'package:app/public/colors.dart';
import 'package:app/public/constants.dart';
import 'package:app/public/strings.dart' as Strings;
import 'package:app/widgets/job_card.dart';
import 'package:app/widgets/step_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:app/utils/utils.dart' as Utils;
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:app/screens/contract/messagebox.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class ContractScreen extends StatefulWidget {
  final String jobId;
  ContractScreen({@required this.jobId});
  ContractScreenState createState() => ContractScreenState();
}

class ContractScreenState extends State<ContractScreen> {
  bool isLoading = false;
  var contract = new Contract();
  var job = new Job();
  var applied = false;
  var step = 0;
  getContract() async {
    setState(() => isLoading = true);
    var res = await UserApi.getContract(widget.jobId);
    if (res['success']) {
      job.fromJson(res['result']['job']);
      if (res['result']['contract'] != null) {
        contract.fromJson(res['result']['contract']);
        applied = true;
      }
    }

    setState(() => isLoading = false);
  }

  acceptClientOffer() async {
    var r = await messageBox(context, content: Strings.acceptClientOffer);
    if (!r) return;
    setState(() => isLoading = true);
    var res = await UserApi.acceptClientOffer(contract.id);
    if (res['success']) {
      this.contract.fromJson(res['result']);
    }
    setState(() => isLoading = false);
  }

  declineClientOffer() async {
    var r = await messageBox(context, content: Strings.declineClientOffer);
    if (!r) return;
    // setState(() => isLoading = true);
    // var res = await UserApi.acceptClientOffer(contract.id);
    // if (res['success']) {
    //   this.contract.fromJson(res['result']);
    // }
    // setState(() => isLoading = false);
  }

  requestFinish() async {
    var r = await messageBox(context, content: Strings.sendFinishRequest);
    if (r == null) return;
    if (!r) return;
    setState(() => isLoading = true);
    var res = await UserApi.requestFinish(contract.id);
    if (res['success']) {
      this.contract.fromJson(res['result']);
    }
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    getContract();
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
                  Strings.contractScreen,
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
              floatingActionButton: Container(
                  width: 40,
                  child: FloatingActionButton(
                    backgroundColor: MainBlue,
                    child: Icon(Icons.chat, size: 20),
                    onPressed: () {},
                  )),
            )));
  }

  Widget jobScreen() {
    if (isLoading) return Container();
    var widget;
    if (contract.step == 0) {
      if (contract.providerAgreed && !contract.clientAgreed)
        widget = Text("お客様の同意を待っています。");
      else if (!contract.providerAgreed && contract.clientAgreed)
        widget = Column(
          children: [
            Text("お客様が、あなたの同意を待っています。"),
            SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                customElevatedButton(
                    text: Strings.accept,
                    backColor: MainRed,
                    height: 32.0,
                    textColor: MainWhite,
                    onPressed: acceptClientOffer),
                customElevatedButton(
                    text: Strings.decline,
                    backColor: MainGrey,
                    height: 32.0,
                    textColor: MainWhite,
                    onPressed: declineClientOffer),
                // ElevatedButton(onPressed: () {}, child: Text("Decline"))
              ],
            )
          ],
        );
      step = 1;
    } else if (contract.step == 1) {
      widget = Text("作業が進行中であります。");
      step = 2;
    } else if (contract.step == 2) {
      widget = Text("作業完了要求を送信しました。\nお客様が結果を確認しています。");
      step = 3;
    } else if (contract.step == 3) {
      widget = Text("作業を評価しています。");
      step = 4;
    } else if (contract.step == 4) {
      widget = Text("作業が完了しました。");
      step = 5;
    }
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 12),
        color: MainWhite,
        // decoration: BoxDecoration(border: Border.all(color: MainBlack)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              StepIndicator(
                step: step,
                steps: 5,
                stepTexts: [
                  Strings.negotiate,
                  Strings.work,
                  Strings.test,
                  Strings.rate,
                  Strings.finish
                ],
              ),
              SizedBox(height: 12),
              widget,
              Column(
                children: [contractPanel(), contractDetail()],
              )
            ],
          ),
        ));
  }

  Widget contractPanel() {
    if (contract.step == 1) {
      return Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              customElevatedButton(
                  text: Strings.requestComplete,
                  backColor: MainRed,
                  height: 32.0,
                  textColor: MainWhite,
                  onPressed: requestFinish)
            ],
          ));
    } else if (contract.step == 3) {
      return Container(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          customElevatedButton(
              text: Strings.rateInput,
              backColor: MainRed,
              height: 32.0,
              textColor: MainWhite,
              onPressed: () {}),
        ],
      ));
    } else
      return Container();
  }

  Widget contractDetail() {
    var title = "";
    var budget = 0;
    var deadline = "";
    var message = "契約文";
    if (contract.step >= 1) {
      title = "両方が同意した条件内容";
      budget = contract.budgetAgreed;
    } else if (contract.providerAgreed) {
      title = "あなたが提案した条件";
      budget = contract.budgetApplied;
    } else if (contract.clientAgreed) {
      title = "お客様が提案した条件";
      budget = contract.budgetApplied;
    }
    if (contract.deadline == null)
      deadline = Strings.noDeadline;
    else
      deadline = Utils.formatDate(contract.deadline);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 12, left: 12, right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          client(),
          SizedBox(height: 6),
          Container(
              height: 30,
              padding: EdgeInsets.only(left: 12, bottom: 4),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  border: Border(left: BorderSide(color: MainRed, width: 4))),
              child: Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              )),
          SizedBox(height: 20),
          Container(
              child: Text(Strings.jobTitle,
                  style: TextStyle(fontWeight: FontWeight.bold))),
          SizedBox(height: 4),
          Text(job.title, overflow: TextOverflow.ellipsis, maxLines: 2),
          SizedBox(height: 16),
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
              child: Text('${budget.toString()}円',
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
              child: Text('$deadline まで', style: TextStyle(color: MainWhite))),
          // Text(deadline),
          SizedBox(height: 16),
          Text(Strings.dateApplied,
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text(Utils.formatDate(contract.dateApplied)),
          SizedBox(height: 16),
          Text(message, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text(contract.message,
              maxLines: 100, overflow: TextOverflow.ellipsis),
          SizedBox(height: 40)
        ],
      ),
    );
  }

  Widget client() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Material(
            color: MainTrans,
            child: InkWell(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                    alignment: Alignment.topRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 4, top: 36),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4.0)),
                                    border:
                                        Border.all(width: .4, color: MainWhite),
                                    color: BlackTrans),
                                child: Text(
                                  job.clientName,
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      TextStyle(color: MainWhite, fontSize: 12),
                                ),
                              ),
                              SizedBox(height: 4),
                              SmoothStarRating(
                                color: MainYellow,
                                borderColor: MainGrey,
                                isReadOnly: true,
                                rating: 4.0,
                                size: 18,
                                onRated: (rating) => {},
                                spacing: 0,
                              ),
                            ],
                          ),
                        ),
                        CachedNetworkImage(
                          imageUrl: (job.clientPhotoUrl == '') ||
                                  (job.clientPhotoUrl == null)
                              ? DEFAULT_AVATAR
                              : job.clientPhotoUrl,
                          imageBuilder: (context, imageProvider) => Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover)),
                          ),
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ],
                    )),
                onTap: () {}))
      ],
    );
  }
}
