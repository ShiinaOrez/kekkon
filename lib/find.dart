import 'package:flutter/material.dart';
import 'package:kekkon/method.dart';
import 'globals.dart' as globals;

final TextEditingController weChatController = new TextEditingController();

Widget makeTextRow(String content) {
  return Row(
    children: [
      SizedBox(width: 20),
      Text(content,
          style: TextStyle(
            decoration: TextDecoration.underline,
          )),
    ],
  );
}

Widget makeInfoCard(BuildContext context, String username, Map data) {
  return InkWell(
    child: SizedBox(
      width: 200,
      height: 230,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Color(0xffC4C4C4),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
            child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              Text(username,
                  style: TextStyle(
                    fontSize: 36,
                    decoration: TextDecoration.underline,
                  )),
              Container(
                height: 20,
              ),
              makeTextRow(("身高: " + data["height"]).padRight(0, " ")),
              Container(
                height: 15,
              ),
              makeTextRow(("体重: " + data["weight"]).padRight(0, " ")),
              Container(
                height: 15,
              ),
              makeTextRow(("教育程度: " + data["edu"]).padRight(0, " ")),
              Container(
                height: 15,
              ),
              makeTextRow(("故乡: " + data["hometown"]).padRight(0, " ")),
            ],
          ),
        )),
      ),
    ),
    onTap: () {
      if (!globals.isLogin) {
        Navigator.popAndPushNamed(context, '/login_requester');
        return;
      }
      showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              backgroundColor: Colors.transparent,
              children: <Widget>[
                SizedBox(
                    width: 350,
                    height: 260,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Color(0xffEF8C8C),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Text("留言",
                                style:
                                    TextStyle(fontSize: 36, color: Colors.white
                                        // decoration: TextDecoration.underline,
                                        )),
                            SizedBox(
                              width: 300,
                              height: 100,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                    color: Colors.white70,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Text("    " + data["msg"] ?? "暂时没有留言～",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black87
                                        // decoration: TextDecoration.underline,
                                        )),
                              ),
                            ),
                            SizedBox(
                              width: 100,
                              child: new TextField(
                                controller: weChatController,
                                decoration: new InputDecoration(
                                  hintText: 'Your WeChat',
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            new ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xff96F6A0),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                              onPressed: () {
                                methodFind(username, weChatController.text,
                                    globals.username);
                                Navigator.pop(context);
                              },
                              child: new Text(
                                'Find He/She !',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black38),
                              ),
                            )
                          ],
                        ),
                      ),
                    ))
              ],
            );
          });
    },
  );
}

List<Widget> makeAllInfoCard(BuildContext context, Map<String, dynamic> data) {
  List<String> rowKeys = [];
  List<Widget> allRow = <Widget>[];
  data.forEach((key, value) {
    // 过滤当前用户本身
    if (key != globals.username) {
      // print("Make info card: [$key] [$value]\n");
      rowKeys.add(key);
      if (rowKeys.length == 4) {
        List<Widget> rowInfoCard = <Widget>[];
        rowKeys.forEach((key) {
          Widget infoCard = makeInfoCard(context, key, data[key] as Map);
          rowInfoCard.add(Padding(
            padding: const EdgeInsets.all(20),
            child: infoCard,
          ));
        });
        allRow.add(Row(children: rowInfoCard));
        // print("[RowAdd]: ${allRow.length}");
        rowKeys.clear();
      }
    }
  });
  if (rowKeys.length > 0) {
    List<Widget> rowInfoCard = <Widget>[];
    rowKeys.forEach((key) {
      Widget infoCard = makeInfoCard(context, key, data[key] as Map);
      rowInfoCard.add(Padding(
        padding: const EdgeInsets.all(20),
        child: infoCard,
      ));
    });
    allRow.add(Row(children: rowInfoCard));
    // print("[RowAdd]: ${allRow.length}");
    rowKeys.clear();
  }
  return allRow;
}

class FindWidget extends StatelessWidget {
  FindWidget() {
    return;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future:
          methodGetAllUsers(), // a previously-obtained Future<String> or null
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        List<Widget> children = <Widget>[];
        if (snapshot.hasData) {
          // print("[snapshot.hasData]: $snapshot.data");
          Map<String, dynamic> data = parseJSON(snapshot.data);
          children = makeAllInfoCard(context, data);
        } else {
          children = const <Widget>[
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text('Awaiting result...'),
            )
          ];
        }
        return Scaffold(
          appBar: AppBar(
            title: Text('Kekkon Application'),
          ),
          backgroundColor: Color(0xffEF8C8C),
          body: Center(
            child: SingleChildScrollView(
              child: Column(children: children),
            ),
          ),
        );
      },
    );
  }
}
