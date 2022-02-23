import 'package:flutter/material.dart';
import 'package:kekkon/method.dart';

Widget buildBlockFromElement(element) {
  return Row(children: [
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          height: 68,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color(0xffEF8C8C),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Finder Name: " +
                  element["finder_name"] +
                  "\n" +
                  "We       Chat  : " +
                  element["we_chat"],
              style: TextStyle(
                  color: Colors.black45,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          )),
    )
  ]);
}

class ProfileWidget extends StatefulWidget {
  ProfileWidget({Key key, this.username}) : super(key: key);
  final String username;
  @override
  _ProfileWidget createState() => _ProfileWidget(this.username);
}

class _ProfileWidget extends State<ProfileWidget> {
  _ProfileWidget(String username) {
    print(username);
    this.username = username;
  }
  String username;
  List<dynamic> finderList;

  Future<bool> _onWillPop() async {
    Navigator.pushNamed(context, "/");
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> leftFinderWidgetList = <Widget>[];
    List<Widget> rightFinderWidgetList = <Widget>[];

    methodGetFinders(this.username).then((value) {
      this.finderList = parseJSON(value);
    });
    if (this.finderList == null) {
      this.finderList = <dynamic>[];
    }

    List<dynamic> leftFinderList =
        this.finderList.sublist(0, this.finderList.length ~/ 2);
    List<dynamic> rightFinderList =
        this.finderList.sublist(this.finderList.length ~/ 2);

    leftFinderList.forEach((element) {
      leftFinderWidgetList.add(buildBlockFromElement(element));
    });
    rightFinderList.forEach((element) {
      rightFinderWidgetList.add(buildBlockFromElement(element));
    });

    return new WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Kekkon Application'),
          ),
          backgroundColor: Color(0xff6CC5E1),
          body: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Center(
                child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: ListView(
                    itemExtent: 100,
                    cacheExtent: 100,
                    addAutomaticKeepAlives: false,
                    children: leftFinderWidgetList,
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: ListView(
                    itemExtent: 100,
                    cacheExtent: 100,
                    addAutomaticKeepAlives: false,
                    children: rightFinderWidgetList,
                  ),
                ),
                SizedBox(
                  width: 4,
                  height: 550,
                  child: DecoratedBox(
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(4))),
                ),
                Expanded(
                    flex: 3,
                    child: Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Center(
                                  child: SizedBox(
                                width: 350,
                                height: 400,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: Color(0xffC4C4C4),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              )),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.blue.shade300,
                              ),
                              height: 60,
                              width: 350,
                              child: TextButton(
                                child: Text(
                                  "重新发布/ Republish",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                      color: Colors.black54),
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, "/requster_publish",
                                      arguments: {
                                        "username": this.username,
                                      });
                                },
                              ),
                            )
                          ],
                        )))
              ],
            )),
          ),
        ));
  }
}
