import 'package:flutter/material.dart';
import 'package:kekkon/method.dart';

class PublishWidget extends StatefulWidget {
  PublishWidget({Key key, this.username}) : super(key: key);
  final String username;
  @override
  _PublishWidget createState() => _PublishWidget(this.username);
}

class _PublishWidget extends State<PublishWidget> {
  _PublishWidget(String username) {
    print(username);

    this.username = username;
  }
  String username;
  final TextEditingController heightController = new TextEditingController();
  final TextEditingController weightController = new TextEditingController();
  final TextEditingController eduController = new TextEditingController();
  final TextEditingController hometownController = new TextEditingController();
  final TextEditingController msgController = new TextEditingController();

  Future<bool> _onWillPop() async {
    Navigator.pushNamed(context, "/");
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            appBar: AppBar(
              title: Text('Kekkon Application'),
            ),
            backgroundColor: Color(0xff6CC5E1),
            body: Padding(
              padding: const EdgeInsets.only(
                  left: 10, right: 10, bottom: 10, top: 10),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      width: 680,
                      height: 530,
                      child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Color(0xffD7D7D7),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(40),
                            child: Column(
                              children: <Widget>[
                                new TextField(
                                  controller: heightController,
                                  decoration: new InputDecoration(
                                    hintText: '身高/ Height',
                                  ),
                                ),
                                new Container(height: 25),
                                new TextField(
                                  controller: weightController,
                                  decoration: new InputDecoration(
                                    hintText: '体重/ Weight',
                                  ),
                                ),
                                new Container(height: 25),
                                new TextField(
                                  controller: eduController,
                                  decoration: new InputDecoration(
                                    hintText: '学历/ Education',
                                  ),
                                ),
                                new Container(height: 25),
                                new TextField(
                                  controller: hometownController,
                                  decoration: new InputDecoration(
                                    hintText: '故乡/ Hometown',
                                  ),
                                ),
                                new Container(height: 25),
                                new TextField(
                                  controller: msgController,
                                  decoration: new InputDecoration(
                                    hintText: '留言/ Message',
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          SizedBox(
                            width: 370,
                            height: 400,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Color(0xffC4C4C4),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: SizedBox(
                              width: 370,
                              height: 100,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Color(0xff96F6A0),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: new ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Color(0xff96F6A0),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                  ),
                                  // 提交登陆请求
                                  onPressed: () {
                                    String ret = "";
                                    methodPublish(
                                            this.username,
                                            heightController.text,
                                            weightController.text,
                                            eduController.text,
                                            hometownController.text,
                                            msgController.text)
                                        .then((value) {
                                      ret = value;
                                      return value == "";
                                      // }).then((success) {
                                      //   showDialog(
                                      //       context: context,
                                      //       builder: (context) {
                                      //         // 展示登陆成功
                                      //         if (success) {
                                      //           print("login success");
                                      //           return AlertDialog(
                                      //               title: Text(
                                      //                   "发布成功/ Publish Success"));
                                      //         }
                                      //         // 展示登陆失败
                                      //         return AlertDialog(
                                      //           title: Text("发布失败/ Publish Failed"),
                                      //           content: new Text(ret),
                                      //         );
                                      //       });
                                      //   return success;
                                    }).then((success) {
                                      if (success) {
                                        Navigator.pushNamed(
                                            context, "/publish_success",
                                            arguments: {
                                              "username": this.username,
                                            });
                                      }
                                    });
                                  },
                                  child: new Text(
                                    'Publish',
                                    style: TextStyle(
                                        fontSize: 60, color: Colors.white70),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      )),
                ],
              ),
            )));
  }
}
