import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:keu/data.dart' as data1;
import 'package:keu/model/apotek_model.dart';
import 'package:keu/screen/widget/dialog_widget.dart';
import 'package:keu/screen/main_screen.dart';
import 'package:keu/screen/authentication/login_page.dart';

class LoginController {
  BuildContext context;
  LoginController(this.context);
  Dio dio = new Dio();
  void sendData(Apotek Apotek) async {
    try {
      if (checkData(Apotek)) {
        try {
          var response =
              await dio.post(data1.urlLogin, data: Apotek.toJsonLogin());
          // If server returns an OK response, parse the JSON
          SharedPreferences _prefs = await SharedPreferences.getInstance();
          _prefs.setString('token', response.data['token']);
          _prefs.commit();
          DialogWidget(context: context, dismiss: true)
              .tampilDialog("Success", "Success login..", MainScreen());
        } on DioError catch (e) {
          // The request was made and the server responded with a status code
          // that falls out of the range of 2xx and is also not 304.
          DialogWidget(context: context, dismiss: false)
              .tampilDialog("Failed", e.message, () {});
        }
      } else {
        DialogWidget(context: context, dismiss: false)
            .tampilDialog("Failed", "The Data cannot empty!", () {});
      }
    } catch (e) {
      DialogWidget(context: context, dismiss: false)
          .tampilDialog("Failed", "The Data cannot empty!", () {});
    }
  }

  bool checkData(Apotek Apotek) {
    if (Apotek.username == null || Apotek.password == null) {
      return false;
    }
    return true;
  }

  void logout() async {
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      _prefs.clear();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: ((context) => LoginPage())));
    } catch (e) {
      throw (e);
    }
  }

  Future<String> checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      checkSession();
      if (prefs.getString('token') == null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: ((context) => LoginPage())));
      }
    } catch (e) {
      DialogWidget(context: context, dismiss: false)
          .tampilDialog("Failed", "The Data cannot empty!", () {});
    }
    return prefs.getString('token');
  }

  Future<Apotek> checkSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dio.options.headers = {
      "Authorization": "Bearer " + prefs.getString('token') ?? ''
    };
    Response response;
    try {
      response = await dio.get(data1.urlCheckSession);
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      print(e.message);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: ((context) => LoginPage())));
    }
    // print(response.data);
    Apotek apotek = Apotek.fromSnapshot(response.data);
    prefs.setString("idApotek", apotek.id);
    prefs.commit();
    return apotek;
  }
}
