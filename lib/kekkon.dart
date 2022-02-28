// This example makes a [Container] react to being entered by a mouse
// pointer, showing a count of the number of entries and exits.

import 'package:flutter/material.dart';

class KekkonWidget extends StatelessWidget {
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
