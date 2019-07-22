import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

import 'package:keu/data.dart' as data1;
import 'package:keu/screen/widget/dialog_widget.dart';
import 'package:keu/screen/main_screen.dart';

import 'package:keu/model/barang_model.dart';
import 'package:keu/model/wishlist_model.dart';
import 'package:keu/model/transaksi_model.dart';

class BarangController {
  SharedPreferences prefs;
  BuildContext context;
  BarangController(this.context);
  Dio dio = new Dio();

  WishList wishList = new WishList();

  Future<String> getToken() async {
    prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  // Obat
  Future<List<Barang>> getDataBarang(String query) async {
    prefs = await SharedPreferences.getInstance();
    List<Barang> listBarang = new List();
    dio.options.headers = {
      "Authorization": "Bearer " + prefs.getString('token') ?? ''
    };
    dio.options.baseUrl = data1.urlBarang;
    try {
      var response = await dio.get('/search-all?query=${query}');
      if (response.statusCode == 200) {
        // If server returns an OK response, parse the JSON
        List<dynamic> map = response.data;
        for (var i = 0; i < map.length; i++) {
          listBarang.add(Barang.fromSnapshot(map[i]));
        }
      }
    } on DioError catch (e) {
      DialogWidget(context: context, dismiss: true)
          .tampilDialog("Failed", e.message.toString(), () {});
    }
    return listBarang;
  }

  Future<List<WishList>> getDataBarangKeb(
      String start, String end, String tipe) async {
    int longStart = DateTime.parse(start).millisecondsSinceEpoch;
    int longEnd = DateTime.parse(end).millisecondsSinceEpoch;

    print(longStart);
    print(longEnd);

    prefs = await SharedPreferences.getInstance();
    dio.options.headers = {
      "Authorization": "Bearer " + prefs.getString('token') ?? ''
    };
    dio.options.baseUrl = data1.urlBarang;

    var response = await dio.get(
        '/by-kategori-and-transaksi-tanggal/${tipe}/${longStart}/${longEnd}');

    List<dynamic> map = response.data;
    List<WishList> listTransaksi = new List();
    print(map.length);
    for (var i = 0; i < map.length; i++) {
      // print(WishList.fromSnapshot(map[i]).toJson());
      listTransaksi.add(WishList.fromSnapshotKeb(map[i]));
    }

    return listTransaksi;
  }

  void inputDataKeb(WishList whislist) async {
    whislist.cariRekomendasi = true;

    prefs = await SharedPreferences.getInstance();
    dio.options.headers = {
      "Authorization": "Bearer " + prefs.getString('token') ?? ''
    };
    print(whislist.toJsonKeb());
    String jsonString = json.encode(whislist.toJsonKeb());
    print(jsonString);
    // print(whislist.transaksi[0].toJson());
    try {
      var response = await dio.post(data1.urlBarang, data: jsonString);
      if (response.statusCode == 200) {
        // If server returns an OK response, parse the JSON
        DialogWidget(context: context, dismiss: true)
            .tampilDialog("Success", "Success to save data..", MainScreen());
      }
    } on DioError catch (e) {
      DialogWidget(context: context, dismiss: true)
          .tampilDialog("Failed", e.message.toString(), () {});
    }
    // if (checkData() && checkData() != null) {
    //   try {
    //     var response =
    //         await dio.post(data1.urlBarang, data: wishList.toJsonKeb());
    //     if (response.statusCode == 200) {
    //       // If server returns an OK response, parse the JSON
    //       DialogWidget(context: context, dismiss: true)
    //           .tampilDialog("Success", "Success to save data..", MainScreen());
    //     }
    //   } on DioError catch (e) {
    //     DialogWidget(context: context, dismiss: true)
    //         .tampilDialog("Failed", e.message.toString(), () {});
    //   }
    // } else {
    //   DialogWidget(context: context, dismiss: true)
    //       .tampilDialog("Failed", "The Data cannot empty!", () {});
    // }
  }

  void deleteDataKeb(String id) async {
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
