// This example makes a [Container] react to being entered by a mouse
// pointer, showing a count of the number of entries and exits.

import 'package:flutter/material.dart';
// import 'dart:io';

// String os = Platform.operatingSystem;
// Map<String, String> envVars = Platform.environment;
// final home = Platform.isMacOS || Platform.isLinux? envVars['HOME']: Platform.isWindows? envVars["UserProfile"]: "/";

class KekkonWidget extends StatefulWidget {
  KekkonWidget({Key key}) : super(key: key);
  @override
  _KekkonWidget createState() => _KekkonWidget();
}

class _KekkonWidget extends State<KekkonWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Kekkon Application'),
        ),
        backgroundColor: Colors.white70,
        body: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Center(
              child: IntrinsicHeight(
            child: Row(
              children: <Widget>[
                // blue button for requester
                Expanded(
                    flex: 1,
                    child: Container(
                      height: 600,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue.shade300,
                      ),
                      child: TextButton(
                        child: Text(
                          "I'm Requester",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                              color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, "/login_requester");
                        },
                      ),
                    )),
                Container(
                  width: 25.0,
                ),
                // pink button for finder
                Expanded(
                    flex: 1,
                    child: Container(
                      height: 600,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xffEF8C8C),
                      ),
                      child: TextButton(
                        child: Text(
                          "I'm Finder",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                              color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, "/find");
                        },
                      ),
                    ))
              ],
            ),
          )),
        ));
  }
}
