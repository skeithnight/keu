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

class BarangController {
  SharedPreferences prefs;
  BuildContext context;
  BarangController(this.context);
  Dio dio = new Dio();

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
}
