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

    if (checkData() && checkData() != null) {
      // print(user.toJsonRegister());
      var response =
          await dio.post(data.urlRegister, data: user.toJsonRegister());
      if (response.statusCode == 200) {
        // If server returns an OK response, parse the JSON
        DialogWidget(context: context, dismiss: true)
            .tampilDialog("Success", "Success to save data..", LoginPage());
      } else {
        // If that response was not OK, throw an error.
      DialogWidget(context: context, dismiss: true)
          .tampilDialog("Failed", "Server data error", (){});
      }
    } else {
      DialogWidget(context: context, dismiss: true)
          .tampilDialog("Failed", "The Data cannot empty!", (){});
    }
  }

  bool checkData() {
    bool result = false;
    if (user != null) {
      if (user.email != null ||
          user.nama != null ||
          user.password != null ||
          user.fcmtoken != null ) {
        result = true;
      }
    }
    return result;
  }
}
