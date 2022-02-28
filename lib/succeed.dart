import 'package:flutter/material.dart';
import 'package:kekkon/method.dart';

Text displayText = new Text('将在 5 秒后跳转',
    style: TextStyle(fontSize: 20, color: Colors.white70));

class SucceedWidget extends StatefulWidget {
  SucceedWidget({Key key, this.type, this.username, this.title})
      : super(key: key);
  final String type;
  final String username;
  final String title;
  @override
  _SucceedWidget createState() =>
      _SucceedWidget(this.type, this.username, this.title);
}

class _SucceedWidget extends State<SucceedWidget> {
  _SucceedWidget(String type, String username, String title) {
    print(username);

    this.type = type;
    this.username = username;
    this.title = title;
  }
  String type;
  String username;
  String title;

  AssetImage image;

  @override
  void initState() {
    super.initState();
    image = AssetImage('assets/images/success.gif');
  }

  @override
  void dispose() {
    image.evict();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Stream<String> display() {
      return Stream.periodic(Duration(seconds: 1), (i) {
        if (i == 4) {
          if (type == "login") {
            // 成功后跳转到 信息页/ 完善信息页
            methodHasPublished(this.username).then((value) {
              // 发布过信息，跳转到查看追求者的页面
              if (value) {
                Navigator.popAndPushNamed(context, "/requster_profile",
                    arguments: {
                      "username": this.username,
                    });
                return;
              }
              // 没发布过，则跳转到完善信息页面
              Navigator.popAndPushNamed(context, "/requster_publish",
                  arguments: {"username": this.username});
            });
          } else if (type == "publish") {
            // 成功后跳转到 信息页
            Navigator.popAndPushNamed(context, "/requster_profile", arguments: {
              "username": this.username,
            });
          }
        }
        return '将在 ${3 - i} 秒后跳转';
      });
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('Kekkon Application'),
        ),
        backgroundColor: Color(0xff6CC5E1),
        body: StreamBuilder<String>(
          stream: display(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            return Center(
                child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    width: 300,
                    height: 300,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Color(0xff6CC5E1),
                        // border: Border.all(color: Colors.white70, width: 15),
                        borderRadius: BorderRadius.circular(150),
                      ),
                      child: Image(
                        image: image,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: SizedBox(
                      height: 100,
                      child: new Text(
                        title,
                        style: TextStyle(fontSize: 60, color: Colors.white70),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    child: new Text('${snapshot.data}',
                        style: TextStyle(fontSize: 20, color: Colors.white70)),
                  )
                ],
              ),
            ));
          },
        ));
  }
}
