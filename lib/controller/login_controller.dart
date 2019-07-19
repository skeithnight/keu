import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:keu/data.dart' as data1;
import 'package:keu/model/user_model.dart';
import 'package:keu/screen/widget/dialog_widget.dart';
import 'package:keu/screen/main_screen.dart';
import 'package:keu/screen/authentication/login_page.dart';

class LoginController {
  BuildContext context;
  LoginController(this.context);
  Dio dio = new Dio();
  void sendData(User user) async {
    try {
      if (checkData(user)) {
        try {
          // print(user.toJsonLogin());
          var response =
              await dio.post(data1.urlLogin, data: user.toJsonLogin());
          // If server returns an OK response, parse the JSON
          SharedPreferences _prefs = await SharedPreferences.getInstance();
          _prefs.setString('token', response.data['token']);
          _prefs.commit();
          DialogWidget(context: context, dismiss: true)
              .tampilDialog("Success", "Success login..", MainScreen());
        } on DioError catch (e) {
          // The request was made and the server responded with a status code
          // that falls out of the range of 2xx and is also not 304.
          if (e.response.statusCode == 401) {
            DialogWidget(context: context, dismiss: false)
                .tampilDialog("Failed", "Email atau Password salah", () {});
          } else {
            DialogWidget(context: context, dismiss: false)
                .tampilDialog("Failed", e.message, () {});
          }
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

  bool checkData(User user) {
    if (user.email == null || user.password == null) {
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

  Future<User> checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    User user = new User();
    try {
      user = await checkSession();
      if (prefs.getString('token') == null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: ((context) => LoginPage())));
      }
    } catch (e) {
      DialogWidget(context: context, dismiss: false)
          .tampilDialog("Failed", "The Data cannot empty!", () {});
    }
    return user;
  }

  Future<User> checkSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dio.options.headers = {
      "Authorization": "Bearer " + prefs.getString('token') ?? ''
    };
    Response response;
    try {
      response = await dio.get(data1.urlCheckSession);
    } on DioError catch (e) {
      print(e.message);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: ((context) => LoginPage())));
    }
    // print(response.data);
    User user = User.fromSnapshot(response.data);
    prefs.setString("idUser", user.id);
    prefs.setString("saldo", user.saldo.toString());
    prefs.commit();
    return user;
  }
}
