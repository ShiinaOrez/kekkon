// This example makes a [Container] react to being entered by a mouse
// pointer, showing a count of the number of entries and exits.

import 'package:flutter/material.dart';
import 'package:kekkon/kekkon.dart';
import 'package:kekkon/login.dart';
import 'package:kekkon/profile.dart';
import 'package:kekkon/publish.dart';
import 'package:kekkon/succeed.dart';
import 'package:kekkon/find.dart';
import 'globals.dart' as globals;

void main() => runApp(KekkonApp());

class KekkonApp extends StatelessWidget {
  // this widget is the root of kekkon application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Kekkon App",
      theme: ThemeData(
        fontFamily: 'Roboto',
        primarySwatch: Colors.blue,
      ),
      home: KekkonWidget(),
      onGenerateRoute: (routeSettings) {
        switch (routeSettings.name) {
          case "/login_requester":
            {
              if (globals.isLogin == true) {
                return new MaterialPageRoute(
                    builder: (context) =>
                        ProfileWidget(username: globals.username));
              }
              return new MaterialPageRoute(builder: (context) => LoginWidget());
            }
          case "/find":
            {
              return new MaterialPageRoute(builder: (context) => FindWidget());
            }
          case "/requster_profile":
            {
              return new MaterialPageRoute(
                  builder: (context) => ProfileWidget(
                      username: (routeSettings.arguments as Map)["username"]));
            }
          case "/requster_publish":
            {
              return new MaterialPageRoute(
                  builder: (context) => PublishWidget(
                      username: (routeSettings.arguments as Map)["username"]));
            }
          case "/login_success":
            {
              return new MaterialPageRoute(
                  builder: (context) => SucceedWidget(
                      type: "login",
                      username: (routeSettings.arguments as Map)["username"],
                      title: '登陆成功/ Succeed'));
            }
          case "/publish_success":
            {
              return new MaterialPageRoute(
                  builder: (context) => SucceedWidget(
                      type: "publish",
                      username: (routeSettings.arguments as Map)["username"],
                      title: '发布成功/ Succeed'));
            }
        }
        // default
        return new MaterialPageRoute(builder: (context) => KekkonWidget());
      },
    );
  }
}
