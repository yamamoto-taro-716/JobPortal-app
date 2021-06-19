import 'package:app/public/colors.dart';
import 'package:app/public/constants.dart';
import 'package:app/public/strings.dart' as Strings;
import 'package:app/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Contracts extends StatelessWidget {
  final List<dynamic> contracts;
  Contracts({this.contracts});
  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];
    widgets.add(Container(
        margin: EdgeInsets.only(bottom: 6),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            color: SecondGrey),
        child: Text('最近応募したワーカー', style: TextStyle(color: MainWhite))));
    if (contracts.length == 0) {
      widgets.add(Text('作業に応募した人はいません。'));
    } else
      widgets
          .add(Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Expanded(child: Text('ワーカー', textAlign: TextAlign.center), flex: 1),
        Expanded(child: Text('応募日時', textAlign: TextAlign.center), flex: 1),
      ]));
    for (var contract in contracts) {
      widgets.add(SizedBox(height: 6));
      widgets.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
              child: Material(
                  color: MainTrans,
                  child: InkWell(
                      child: Row(children: [
                        smallAvatar(contract['provider_id']['photo_url']),
                        SizedBox(width: 12),
                        Text(contract['provider_id']['full_name'])
                      ]),
                      onTap: () {})),
              flex: 1),
          Expanded(
              child: Text(formatDate(DateTime.parse(contract['date_applied'])),
                  textAlign: TextAlign.center),
              flex: 1),
        ],
      ));
    }

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets,
      ),
    );
  }

  smallAvatar(photoUrl) {
    return CachedNetworkImage(
      imageUrl:
          (photoUrl == '') || (photoUrl == null) ? DEFAULT_AVATAR : photoUrl,
      imageBuilder: (context, imageProvider) => Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
            // border: Border.all(color: MainGrey),
            borderRadius: BorderRadius.all(Radius.circular(15)),
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover)),
      ),
      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
