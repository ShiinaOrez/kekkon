// This example makes a [Container] react to being entered by a mouse
// pointer, showing a count of the number of entries and exits.

import 'package:flutter/material.dart';
import 'package:kekkon/method.dart';
import 'globals.dart' as globals;

class LoginWidget extends StatefulWidget {
  LoginWidget({Key key}) : super(key: key);
  @override
  _LoginWidget createState() => _LoginWidget();
}

class _LoginWidget extends State<LoginWidget> {
  final TextEditingController userNameController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kekkon Application'),
      ),
      backgroundColor: Color(0xff6CC5E1),
      body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Column(
                children: [
                  SizedBox(
                    width: 700,
                    height: 380,
                    child: Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 120,
                            width: 600,
                          ),
                          SizedBox(
                            width: 600,
                            height: 100,
                            child: new TextField(
                              controller: userNameController,
                              decoration: new InputDecoration(
                                hintText: '用户名/ UserName',
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 600,
                            height: 100,
                            child: new TextField(
                              controller: passwordController,
                              decoration: new InputDecoration(
                                hintText: '密码/ Password',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 700,
                    height: 100,
                    child: Center(
                      child: SizedBox(
                        width: 300,
                        height: 70,
                        child: new ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          // 提交登陆请求
                          onPressed: () {
                            String ret = "";
                            methodLogin(userNameController.text,
                                    passwordController.text)
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
                              //               title: Text("登陆成功/ Login Success"));
                              //         }
                              //         // 展示登陆失败
                              //         return AlertDialog(
                              //           title: Text("登陆失败/ Login Failed"),
                              //           content: new Text(ret),
                              //         );
                              //       });
                              //   return success;
                            }).then((success) {
                              if (success) {
                                globals.isLogin = true;
                                globals.username = userNameController.text;
                                // 成功后跳转到 信息页/ 完善信息页
                                Navigator.pushNamed(context, "/login_success",
                                    arguments: {
                                      "username": userNameController.text,
                                    });
                                return;
                              }
                            });
                          },
                          child: new Text('登陆/ Login',
                              style: TextStyle(fontSize: 30)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 370,
                height: 520,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      color: Color(0xffC4C4C4),
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ],
          )),
    );
  }
}
