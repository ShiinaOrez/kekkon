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
              "Finder Name:   " +
                  element["finder_name"] +
                  "\n" +
                  "We       Chat  :    " +
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

  Future<bool> _onWillPop() async {
    Navigator.pushNamed(context, "/");
  }

  List<List<Widget>> loadFinders(String value) {
    List<dynamic> finderList = parseJSON(value);

    List<dynamic> leftFinderList =
        finderList.sublist(0, finderList.length ~/ 2);
    List<dynamic> rightFinderList = finderList.sublist(finderList.length ~/ 2);

    if (rightFinderList.length > leftFinderList.length) {
      leftFinderList.add(rightFinderList.last);
      rightFinderList.removeLast();
    }

    List<Widget> leftFinderWidgetList = [];
    List<Widget> rightFinderWidgetList = [];

    leftFinderList.forEach((element) {
      leftFinderWidgetList.add(buildBlockFromElement(element));
    });
    rightFinderList.forEach((element) {
      rightFinderWidgetList.add(buildBlockFromElement(element));
    });

    List<List<Widget>> result = [];
    result.add(leftFinderWidgetList);
    result.add(rightFinderWidgetList);

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: _onWillPop,
        child: FutureBuilder<String>(
          future: methodGetFinders(
              this.username), // a previously-obtained Future<String> or null
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            List<List<Widget>> children = [];
            if (snapshot.hasData) {
              children = this.loadFinders(snapshot.data);
            } else {
              children = [<Widget>[], <Widget>[]];
            }
            return Scaffold(
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
                          children: children[0],
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: ListView(
                          itemExtent: 100,
                          cacheExtent: 100,
                          addAutomaticKeepAlives: false,
                          children: children[1],
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
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Center(
                                            child: Text(
                                                '-- HELP INFORMATION --' +
                                                    '\n  + 本页面展示对您感兴趣的人的列表～' +
                                                    '\n  + 第一次发布个人信息后此页为空～' +
                                                    '\n  + 可以通过下方的「重新发布」按钮' +
                                                    '\n来更改个人信息～')),
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
                ));
          },
        ));
  }
}
