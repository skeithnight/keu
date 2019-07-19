import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:keu/data.dart' as data1;
import 'package:keu/model/wishlist_model.dart';

import 'package:keu/screen/widget/dialog_widget.dart';

import 'package:keu/screen/main_screen.dart';

class WishListController {
  SharedPreferences prefs;
  BuildContext context;
  WishListController(this.context);
  Dio dio = new Dio();

  WishList wishList = new WishList();

  Future<String> getToken() async {
    prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  Future<List<WishList>> getDataWishList() async {
    int endDate = new DateTime.now().millisecondsSinceEpoch;
    prefs = await SharedPreferences.getInstance();
    dio.options.headers = {
      "Authorization": "Bearer " + prefs.getString('token') ?? ''
    };
    dio.options.baseUrl = data1.urlBarang;

    var response = await dio.get('');

    // print(response.data);
    List<dynamic> map = response.data;
    List<WishList> listWishList = new List();
    for (var i = 0; i < map.length; i++) {
      listWishList.add(WishList.fromSnapshot(map[i]));
    }

    return listWishList;
  }

  void inputDataWishList(String keyword) async {
    wishList.nama = keyword;
    wishList.cariRekomendasi = true;
    wishList.kategori = "Wishlist";

    prefs = await SharedPreferences.getInstance();
    dio.options.headers = {
      "Authorization": "Bearer " + prefs.getString('token') ?? ''
    };
    if (checkData() && checkData() != null) {
      // print(user.toJsonRegister());
      try {
        var response =
            await dio.post(data1.urlBarang, data: wishList.toJsonWishList());
        if (response.statusCode == 200) {
          // If server returns an OK response, parse the JSON
          DialogWidget(context: context, dismiss: true)
              .tampilDialog("Success", "Success to save data..", MainScreen());
        }
      } on DioError catch (e) {
        DialogWidget(context: context, dismiss: true)
            .tampilDialog("Failed", e.message.toString(), () {});
      }
    } else {
      DialogWidget(context: context, dismiss: true)
          .tampilDialog("Failed", "The Data cannot empty!", () {});
    }
  }

  void deleteDataWishList(String id) async {
    prefs = await SharedPreferences.getInstance();
    dio.options.headers = {
      "Authorization": "Bearer " + prefs.getString('token') ?? ''
    };
    try {
      var response = await dio.delete(data1.urlBarang + '/' + id);
      if (response.statusCode == 200) {
        // If server returns an OK response, parse the JSON
        DialogWidget(context: context, dismiss: true)
            .tampilDialog("Success", "Success to delete data..", MainScreen());
      }
    } on DioError catch (e) {
      DialogWidget(context: context, dismiss: true)
          .tampilDialog("Failed", e.message.toString(), () {});
    }
  }

  bool checkData() {
    bool result = false;
    if (wishList != null) {
      if (wishList.nama != null &&
          wishList.cariRekomendasi != null &&
          wishList.kategori != null) {
        result = true;
      }
    }
    return result;
  }
}
