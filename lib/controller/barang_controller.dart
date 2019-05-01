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
    dio.options.headers = {
      "Authorization": "Bearer " + prefs.getString('token') ?? ''
    };
    dio.options.baseUrl = data1.urlBarang;

    var response = await dio.get('/search-all?query=${query}');
    
    List<dynamic> map = response.data;
    List<Barang> listBarang = new List();
    for (var i = 0; i < map.length; i++) {
      listBarang.add(Barang.fromSnapshot(map[i]));
    }

    return listBarang;
  }
}
