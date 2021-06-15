import 'package:app/models/user.dart';
import 'package:app/public/colors.dart';
import 'package:app/public/constants.dart';
import 'package:app/public/strings.dart' as Strings;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavDrawer extends StatelessWidget {
  final logout;
  final User profile;
  NavDrawer({this.logout, this.profile});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CachedNetworkImage(
                      imageUrl:
                          (profile.photoUrl == '') || (profile.photoUrl == null)
                              ? DEFAULT_AVATAR
                              : profile.photoUrl,
                      imageBuilder: (context, imageProvider) => Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                            border: Border.all(color: MainGrey),
                            borderRadius: BorderRadius.all(Radius.circular(60)),
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover)),
                      ),
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                    SizedBox(height: 12),
                    Text(
                      profile.fullName,
                      style: TextStyle(color: MainWhite, fontSize: 20),
                    )
                  ]),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [MainBlue, MainGreen]))),
          ListTile(
            leading: Icon(Icons.person),
            title: Text(Strings.profile),
            onTap: () {
              Navigator.popAndPushNamed(context, PROFILE_SCREEN);
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(Strings.setting),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
              leading: Icon(Icons.logout),
              title: Text(Strings.logout),
              onTap: logout),
        ],
      ),
    );
  }
}
