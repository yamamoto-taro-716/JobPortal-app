import 'package:app/apis/user.dart';
import 'package:app/components/custom-elevated-button.dart';
import 'package:app/components/custom_input.dart';
import 'package:app/models/job.dart';
import 'package:app/public/colors.dart';
import 'package:flutter/material.dart';
import 'package:app/public/strings.dart' as Strings;
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:app/screens/contract/messagebox.dart';
import 'package:app/utils/utils.dart' as Utils;

class ApplySheet extends StatefulWidget {
  final String jobId;
  @override
  ApplySheet({this.jobId});
  @override
  State<StatefulWidget> createState() => ApplySheetState();
}

class ApplySheetState extends State<ApplySheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController budgetController = new TextEditingController();
  TextEditingController deadlineController = new TextEditingController();
  TextEditingController messageController = new TextEditingController();

  var phoneValid = true,
      priceValid = true,
      deadlineValid = true,
      messageValid = true;
  DateTime deadline;

  phoneValidator(String phone) {
    if (phone.length > 13 || phone.length < 10)
      setState(() => phoneValid = false);
    else
      setState(() => phoneValid = true);
  }

  priceValidator(String price) {
    if (price == null ||
        price == '' ||
        double.parse(price) < 500 ||
        double.parse(price) > 1000000)
      setState(() => priceValid = false);
    else
      setState(() => priceValid = true);
  }

  deadlineValidator() {
    if (deadline == null ||
        deadline.difference(DateTime.now()).inDays > 180 ||
        deadline.difference(DateTime.now()).inDays < 0)
      setState(() => deadlineValid = false);
    else
      setState(() => deadlineValid = true);
  }

  messageValidator(message) {
    if (message.length < 10)
      setState(() => messageValid = false);
    else
      setState(() => messageValid = true);
  }

  apply() async {
    phoneValidator(phoneController.text);
    priceValidator(budgetController.text);
    deadlineValidator();
    messageValidator(messageController.text);
    if (phoneValid && priceValid && deadlineValid && messageValid) {
      var r = await messageBox(context,
          content: Strings.agreeApply,
          yes: Strings.applytoThis,
          no: Strings.closeMessage);
      if (!r) return;

      var res = await UserApi.applyJob(widget.jobId, phoneController.text,
          budgetController.text, messageController.text, deadline.toString());

      Navigator.of(context).pop(res['success']);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      height: 580,
      decoration: BoxDecoration(
          color: MainWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
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
                  inputFormatters: [
                    MaskTextInputFormatter(mask: '#############')
                  ]),
              phoneValid ? Container() : errorMsg('数字、10桁以上、13桁以下'),
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
                  inputFormatters: [MaskTextInputFormatter(mask: '#######')],
                  validator: (price) => null,
                  suffixIcon: Container(
                      width: 12,
                      alignment: Alignment.centerRight,
                      margin: EdgeInsets.only(right: 18),
                      child: Text(
                        '円',
                        style: TextStyle(color: MainBlue),
                      ))),
              priceValid ? Container() : errorMsg('数字、500円以上、100万円以下'),
              SizedBox(height: 12),
              Text(
                Strings.estDeadline,
                style: TextStyle(color: MainBlack),
              ),
              SizedBox(height: 8),
              Stack(children: [
                CustomInputField(
                    borderColor: WeakGrey,
                    placeHolder: Strings.estDeadline,
                    controller: deadlineController,
                    readOnly: true,
                    validator: (deadline) => null,
                    suffixIcon: Icon(Icons.insert_invitation, color: MainBlue)),
                Material(
                    color: MainTrans,
                    child: InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(24.0)),
                      child: Container(
                          height: 40,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: MainTrans,
                            border: Border.all(color: WeakGrey),
                            borderRadius:
                                BorderRadius.all(Radius.circular(24.0)),
                          ),
                          padding: EdgeInsets.only(
                              left: 12.0, right: 0, top: 0, bottom: 0)),
                      onTap: () async {
                        deadline = await showRoundedDatePicker(
                            context: context,
                            firstDate: DateTime.now(),
                            initialDate: DateTime.now(),
                            lastDate: DateTime.now().add(Duration(days: 180)));
                        if (deadline == null) return;
                        deadlineController.text = Utils.formatDate(deadline);
                        setState(() {});
                      },
                    ))
              ]),
              deadlineValid ? Container() : errorMsg('現在日から、180日後まで'),
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
                paddingTop: 8,
                controller: messageController,
                validator: (message) => null,
              ),
              messageValid ? Container() : errorMsg('10文字以上'),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  customElevatedButton(
                      text: Strings.applytoThis,
                      backColor: MainRed,
                      onPressed: apply)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget errorMsg(msg) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(top: 4, left: 12),
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
              color: MainRed,
              borderRadius: BorderRadius.all(Radius.circular(4))),
          child: Text(
            '必須',
            style: TextStyle(color: MainWhite, fontSize: 12),
          ),
        ),
        SizedBox(width: 8),
        Container(
            margin: EdgeInsets.only(top: 4),
            child: Text(
              msg,
              style: TextStyle(color: MainRed, fontSize: 12),
            ))
      ],
    );
  }
}
