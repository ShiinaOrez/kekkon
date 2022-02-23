import 'package:flutter/material.dart';
import 'package:kekkon/method.dart';
import 'globals.dart' as globals;

final TextEditingController weChatController = new TextEditingController();

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
              Text(("身高: " + data["height"]).padRight(36, " "),
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                  )),
              Container(
                height: 15,
              ),
              Text(("体重: " + data["weight"]).padRight(36, " "),
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                  )),
              Container(
                height: 15,
              ),
              Text(("教育程度: " + data["edu"]).padRight(26, " "),
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                  )),
              Container(
                height: 15,
              ),
              Text(("故乡: " + data["hometown"]).padRight(36, " "),
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                  ))
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
  List<Widget> rowInfoCard = <Widget>[];
  List<Widget> allRow = <Widget>[];
  data.forEach((key, value) {
    // 过滤当前用户本身
    if (key != globals.username) {
      Widget infoCard = makeInfoCard(context, key, value as Map);
      rowInfoCard.add(Padding(
        padding: const EdgeInsets.all(20),
        child: infoCard,
      ));
      if (rowInfoCard.length == 4) {
        allRow.add(Row(children: rowInfoCard));
        rowInfoCard.clear();
      }
    }
  });
  if (rowInfoCard.length > 0) {
    allRow.add(Row(
      children: rowInfoCard,
    ));
  }
  return allRow;
}

class FindWidget extends StatefulWidget {
  FindWidget({Key key}) : super(key: key);
  @override
  _FindWidget createState() => _FindWidget();
}

class _FindWidget extends State<FindWidget> {
  _FindWidget() {
    return;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future:
          methodGetAllUsers(), // a previously-obtained Future<String> or null
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        List<Widget> children;
        if (snapshot.hasData) {
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
