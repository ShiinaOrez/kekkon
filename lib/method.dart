import 'package:flutter/services.dart';
import 'dart:convert';

const requesterCh = MethodChannel("kekkon/requester");

Future<String> methodLogin(String username, String password) async {
  final String value = await requesterCh
      .invokeMethod('login', {"username": username, "password": password});
  return value;
}

Future<bool> methodHasPublished(String username) async {
  final bool value =
      await requesterCh.invokeMethod('has_published', {"username": username});
  print('[HasPublished]: return $value');
  return value;
}

Future<String> methodGetFinders(String username) async {
  final String value = await requesterCh.invokeMethod('get_finders', {
    "username": username,
  });
  return value;
}

Future<String> methodPublish(String username, String height, String weight,
    String edu, String hometown, String msg) async {
  final String value = await requesterCh.invokeMethod('publish', {
    "username": username,
    "height": height,
    "weight": weight,
    "edu": edu,
    "hometown": hometown,
    "msg": msg
  });
  return value;
}

Future<String> methodFind(String username, String weChat, String finder) async {
  print("[MethodFinder]: " + username);
  final String value = await requesterCh.invokeMethod('find', {
    "username": username,
    "wechat": weChat,
    "finder": finder,
  });
  return value;
}

Future<String> methodGetAllUsers() async {
  final String value = await requesterCh.invokeMethod('get_all_users', {});
  return value;
}

dynamic parseJSON(String data) {
  return json.decode(data);
}
