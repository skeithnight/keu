import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'package:keu/data.dart' as data;
import 'package:keu/model/user_model.dart';
import 'package:keu/screen/widget/dialog_widget.dart';
import 'package:keu/screen/authentication/login_page.dart';
import 'package:keu/screen/authentication/sign_up_page.dart';

class RegisterController {
  BuildContext context;
  RegisterController(this.context);
  Dio dio = new Dio();
  User user = new User();
  void sendData(User _user) async {
    user = _user;
    try {
      if (checkData(user)) {
        try {
          // print(user.toJsonLogin());
          var response =
              await dio.post(data.urlRegister, data: user.toJsonRegister());
          // If server returns an OK response, parse the JSON
          DialogWidget(context: context, dismiss: true)
              .tampilDialog("Success", "Sukses Daftar..", LoginPage());
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
          .tampilDialog("Failed", e.message, () {});
    }
  }

  bool checkData(User _user) {
    bool result = false;
    if (_user != null) {
      if (_user.email != null &&
          _user.nama != null &&
          _user.password != null &&
          _user.fcmtoken != null) {
        result = true;
      }
    }
    return result;
  }
}
